import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/validators.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/models/register_user.dart';
import 'package:futgolazo/src/models/country.model.dart';
import 'package:futgolazo/src/utils/utils.dart' as utils;
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/services/auth_services.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/repositories/user.repository.dart';
import 'package:futgolazo/src/bloc/base/validation_item_block.dart';
import 'package:futgolazo/src/repositories/general.repository.dart';

class SignUpBloc extends BaseBloc {
  CountryInfo currentCountryInfo;

  final PageController pageController;

  AuthService _authService;
  UserRepository _userRespository;
  GeneralRepository _generalRepository;

  StreamSubscription<bool> userPhoneSubscription;
  StreamSubscription<List<CountryInfo>> countriesSubscription;

  Stream currentUser$;
  StreamController _countries$;

  ValidationItemBloc<String> _emailController;
  ValidationItemBloc<String> _passwordController;
  ValidationItemBloc<bool> acceptConditionController;
  ValidationItemBloc<bool> acceptAdultController;
  ValidationItemBloc<bool> acceptNotiMail;

  ValidationItemBloc<String> _lastNameController;
  ValidationItemBloc<String> _firstNameController;
  ValidationItemBloc<String> _nickNameController;

  ValidationItemBloc<String> _cellPhoneController;
  ValidationItemBloc<CountryInfo> countryController;

  ValidationItemBloc<String> userValidationCodeController;

  BehaviorSubject repeatedPassword$ = BehaviorSubject<String>();

  SignUpBloc({@required this.pageController}) {
    _userRespository = UserRepository();
    _generalRepository = GeneralRepository();
    _authService = GetIt.I<PoolServices>().authService;

    fetchCountries();

    currentUser$ = GetIt.I<PoolServices>().dataService.user$;

    _countries$ = StreamController<List<CountryInfo>>();

    _emailController = ValidationItemBloc(validators: [
      ValidatorError(
        'requerido',
        Validators.exist,
      ),
      ValidatorError(
        'Mail mal formado',
        Validators.emailValidatorFunc,
      ),
    ]);

    countryController = ValidationItemBloc(validators: []);

    _cellPhoneController = ValidationItemBloc(validators: [
      ValidatorError(
        'El teléfono es requerido',
        Validators.exist,
      ),
    ]);

    _passwordController = ValidationItemBloc(validators: [
      ValidatorError(
        'Contraseña es requerida',
        Validators.exist,
      ),
      ValidatorError(
        'Contraseña debe tener como mínimo 5  caracteres.',
        Validators.minLength(5),
      ),
    ]);

    acceptNotiMail = ValidationItemBloc(validators: []);
    
    acceptConditionController = new ValidationItemBloc(validators: [
      new ValidatorError(
        'Debe aceptar los términos y condiciones',
        Validators.accept,
      )
    ]);
    acceptAdultController = new ValidationItemBloc(validators: [
      new ValidatorError('Debe aceptar ser mayor de edad', Validators.accept)
    ]);

    _firstNameController = ValidationItemBloc(validators: [
      ValidatorError(
        'Nombre es requerido',
        Validators.exist,
      ),
    ]);

    _lastNameController = ValidationItemBloc(validators: [
      ValidatorError(
        'Apellido es requerido',
        Validators.exist,
      ),
    ]);

    _nickNameController = ValidationItemBloc(validators: [
      ValidatorError('NickName es requerido', Validators.exist)
    ]);

    userValidationCodeController = ValidationItemBloc(validators: [
      ValidatorError(
        'Código tiene 6 dígitos',
        (String data) => Validators.stringLengthValidators(data, 6),
      ),
    ]);

    // INGRESO FLUJO DE PAIS TELEFONO
    Stream inputData$ = _cellPhoneController.itemStream
        .distinct()
        .debounce((_) => TimerStream(true, Duration(milliseconds: 300)))
        .where((phoneString) => phoneString.length > 5);

    userPhoneSubscription = CombineLatestStream.combine2(
        countryController.itemStream.asyncMap((country) => country.countryCode),
        inputData$, (countryCode, phoneNumber) {
      return {'countryCode': countryCode, 'phoneNumber': phoneNumber};
    }).switchMap((mapObj) async* {
      yield await _userRespository.phoneIsValid(
          mapObj['phoneNumber'], mapObj['countryCode']);
    }).listen((result) {
      if (!result) {
        _cellPhoneController.subject$.addError('Telefono no valido');
      }
    });
  }

  Stream<List<CountryInfo>> get countries$ => _countries$.stream;

  ValidationItemBloc get emailField => _emailController;
  ValidationItemBloc get passwordField => _passwordController;
  ValidationItemBloc get lastNameField => _lastNameController;
  ValidationItemBloc get firstNameField => _firstNameController;
  ValidationItemBloc get nickNameField => _nickNameController;
  ValidationItemBloc get cellPhoneField => _cellPhoneController;

  Stream<String> get repeatedPasswordField => CombineLatestStream.combine2(
          _passwordController.itemStream, repeatedPassword$.stream,
          (password, repeatedPassword) {
        return [password, repeatedPassword];
      }).transform(
          StreamTransformer.fromHandlers(handleData: (inputData, sink) {
        final String pass = inputData[0];
        final String repPass = inputData[1];

        if (pass == repPass) {
          sink.add(repPass);
        } else {
          sink.addError('Contraseña no son iguales!');
        }
      }));

  // COMBINE ALL OBSERVER INTO ONE
  Stream<bool> get firstScreenValidForm => CombineLatestStream.combine5(
          _emailController.itemStream,
          _passwordController.itemStream,
          repeatedPasswordField,
          acceptAdultController.itemStream,
          acceptConditionController.itemStream, (a, b, c, d, e) {
        return [d, e];
      }).transform(
        StreamTransformer.fromHandlers(
          handleData: (inputData, sink) {
            if (inputData[0] && inputData[1]) {
              sink.add(true);
            } else {
              sink.addError('error');
            }
          },
        ),
      );

  Stream<bool> get secondScreenValidForm => CombineLatestStream.combine3(
      firstNameField.itemStream,
      lastNameField.itemStream,
      nickNameField.itemStream,
      (a, b, c) => true);

  @override
  void dispose() {
    _countries$.close();
    repeatedPassword$.close();
    _emailController.dispose();
    countryController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _cellPhoneController.dispose();
    _nickNameController.dispose();
    acceptConditionController.dispose();
    acceptAdultController.dispose();
    userValidationCodeController.dispose();

    countriesSubscription.cancel();
    userPhoneSubscription.cancel();
  }

  backToFirstScreen() {
    _movePage(0);
  }

  gotoSecondScreen() {
    _movePage(1);
  }

  gotoThirdScreen() {
    _movePage(2);
  }

  gotoEnterValidationScreen() {
    _movePage(3);
  }

  _movePage(int page) {
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  fetchCountries() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    Stream<List<CountryInfo>> streamFromFuture =
        Stream.fromFuture(_generalRepository.getCountries());

    countriesSubscription = streamFromFuture.listen(
        (onData) {
          currentCountryInfo =
              onData.firstWhere((element) => element.selected == true);
          countryController.addDataToStream(currentCountryInfo);
          _countries$.sink.add(onData);
        },
        onError: (error) {},
        onDone: () {
          GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
        });
  }

  doRegister() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();
    RegisterUser newUser = _createRegisterObject();

    var resp = await _authService.register(newUser);

    if (resp.status == GenericResponseStatus.COMPLETED) {
      await _authService.sendOTP(jsonEncode({'phone': newUser.phone}));
      gotoEnterValidationScreen();
      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    } else {
      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      String errorMessage;
      switch (resp.errorStatus) {
        case 401:
          errorMessage =
              'Usuario o contraseña no son correctos. Ingrese credenciales válidas.';
          break;
        case 428:
          errorMessage = 'El teléfono o correo electrónico ya existen';
          break;
        case 417:
          errorMessage =
              'EL correo ingresado no es válido o su procedencia no puede ser verificada.';
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
          errorMessage = 'Tenemos inconvenientes revisa tu conexión a Internet';
          break;
        default:
          errorMessage = 'Ha ocurrido un error inesperado.';
          break;
      }
      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
    }
  }

  otpValidation(BuildContext context) async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    final user = GetIt.I<PoolServices>().dataService.user;

    final otpModel = {
      'smsVerificationCode': userValidationCodeController.rawValue,
      'email': user.email,
      'phoneUpdateOnly': 'false',
    };

    var resp = await _authService.verifyOTPAccount(jsonEncode(otpModel));

    if (resp.status == GenericResponseStatus.COMPLETED) {
      await _authService.getLastUserInfo();

      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      Navigator.pushReplacementNamed(context, NavigationRoute.WELCOME);
    } else {
      GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
      String errorMessage;
      switch (resp.errorStatus) {
        case 304:
          errorMessage = 'El código ingresado es incorrecto';
          break;
        case 417:
          errorMessage = '${resp.message}';
          break;
        default:
          errorMessage = '${resp.message}';
          break;
      }
      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
    }
  }

  resendOtp(BuildContext context) async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    final user = GetIt.I<PoolServices>().dataService.user;
    final genericResponse =
        await _authService.sendOTP(jsonEncode({'phone': user.phone}));

    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      utils.showAlert(
          context, 'Se ha enviado un codigo al correo ${user.email}');
    } else {
      var msm = '';
      switch (genericResponse.errorStatus) {
        case 503:
          msm = "Has alcazado el límite de solicitudes diarias";
          break;
        case 0:
          msm = 'Tenemos inconvenientes. Revisa tu conexión a Internet';
          break;
        default:
          msm = 'Ha ocurrido un error';
      }
      utils.showAlert(context, msm);
    }
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
  }

  RegisterUser _createRegisterObject() {
    final RegisterUser registerUser = RegisterUser(
      promotionalCode: '',
      email: _emailController.rawValue,
      username: nickNameField.rawValue,
      repeatpass: repeatedPassword$.value,
      phone: _cellPhoneController.rawValue,
      adult: acceptAdultController.rawValue,
      lastName: _lastNameController.rawValue,
      password: _passwordController.rawValue,
      countryInfo: countryController.rawValue,
      firstName: _firstNameController.rawValue,
      acceptTerms: acceptConditionController.rawValue,
      allowEmailNotifications: acceptNotiMail.rawValue ?? false,
      firebaseToken: GetIt.I<PoolServices>().pushNotificationProvider.tokenFCM,
    );

    return registerUser;
  }
}
