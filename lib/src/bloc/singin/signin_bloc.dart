import 'dart:async';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:futgolazo/src/utils/validators.dart';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/enums/origin_type.enum.dart';
import 'package:futgolazo/src/services/auth_services.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/networking/generic_response.dart';

class SigninBloc extends BaseBloc with Validators {
  AuthService _authService;

  final _mailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  SigninBloc() {
    _authService = GetIt.I<PoolServices>().authService;
  }

  // STREAMS
  Stream<String> get emailStrem =>
      _mailController.stream.transform(emailValidator);
  Stream<String> get passwordStrem =>
      _passwordController.stream.transform(passwordValidator);

  // SINKS
  Function(String) get setEmail => _mailController.sink.add;
  Function(String) get setPassword => _passwordController.sink.add;

  // COMBINE ALL OBSERVER INTO ONE
  Stream<bool> get validForm =>
      CombineLatestStream.combine2(emailStrem, passwordStrem, (a, b) => true);

  String get email => _mailController.value;
  String get password => _passwordController.value;

  @override
  void dispose() {
    _mailController?.close();
    _passwordController?.close();
  }

  doLogin() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    final loginObject = {
      "email": this.email,
      "password": this.password,
      "origin": 1,
      "firebaseToken": GetIt.I<PoolServices>().pushNotificationProvider.tokenFCM
    };

    GenericResponse genericResponse = await _authService.login(loginObject);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      bool loginResponse = genericResponse.data != null;
      if (loginResponse) {
        final user = UserModel.fromJsonMap(genericResponse.data);
        if (user.isVerified) {
          Get.offNamed(NavigationRoute.HOME);
        } else {
          GetIt.I<PoolServices>()
              .loadingService
              .showErrorSnackbar('Tu cuenta no está verificada');
          Get.offAllNamed(NavigationRoute.SIGNUP, arguments: {"page": 2});
          return;
        }
      }
    } else {
      String errorMessage = '';
      switch (genericResponse.errorStatus) {
        case 401:
          errorMessage =
              'Usuario o contraseña no son correctos. Ingrese credenciales válidas.';
          break;
        case 428:
          errorMessage = 'Correo o contraseña incorrectos';
          break;
        case 429:
          errorMessage = 'Tu correo está asociado a una cuenta Facebook.';
          break;
        case 431:
          errorMessage = 'Tu correo está asociado a una cuenta Google.';
          break;
        case 451:
          errorMessage = 'Tu correo ya está asociado a una cuenta.';
          break;
        case 0:
          errorMessage = "Tenemos inconvenientes revisa tu conexión a Internet";
          break;
        default:
          errorMessage = 'Ha ocurrido un error inesperado.';
          break;
      }

      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
    }
  }

  Future<String> validateEmailLogin() async {
    String errorMessage = '';
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    GenericResponse genericResponse =
        await _authService.validateEmailLogin(email);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    if (genericResponse.status == GenericResponseStatus.ERROR) {
      switch (genericResponse.errorStatus) {
        case 404:
          errorMessage =
              'No se encuentra un usuario registrado con el correo proporcionado.';
          break;
        case 0:
          errorMessage = 'Tenemos inconvenientes revisa tu conexión a Internet';
          break;
        default:
          errorMessage = 'Ha ocurrido un error inesperado.';
          break;
      }
    } else {
      OriginTypeEnum origin = EnumToString.fromString(
          OriginTypeEnum.values, genericResponse.data['origin']);
      if (origin == OriginTypeEnum.FACEBOOK) {
        errorMessage = 'Tu correo está asociado a una cuenta Facebook.';
      } else if (origin == OriginTypeEnum.GOOGLE) {
        errorMessage = 'Tu correo está asociado a una cuenta Google.';
      }
    }

    if (errorMessage.isNotEmpty) {
      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
      return null;
    }

    return genericResponse.data['username'];
  }
}
