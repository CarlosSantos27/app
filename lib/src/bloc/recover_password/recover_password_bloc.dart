import 'dart:async';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/validators.dart';
import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/services/auth_services.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/bloc/base/validation_item_block.dart';

class RecoverPasswordBloc extends BaseBloc {
  final PageController pageController;

  AuthService _authService;

  ValidationItemBloc<String> _emailController;
  ValidationItemBloc<String> _passwordController;
  ValidationItemBloc<String> _oldPasswordController;
  BehaviorSubject repeatedPassword$ = BehaviorSubject<String>();

  RecoverPasswordBloc({this.pageController}) {
    _authService = GetIt.I<PoolServices>().authService;

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

    _oldPasswordController = ValidationItemBloc(validators: [
      ValidatorError(
        'Contraseña temporal es requerida',
        Validators.exist,
      ),
      ValidatorError(
        'Contraseña debe tener como mínimo 5  caracteres.',
        Validators.minLength(5),
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
  }

  ValidationItemBloc get emailField => _emailController;
  ValidationItemBloc get passwordField => _passwordController;
  ValidationItemBloc get oldPasswordField => _oldPasswordController;

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
  Stream<bool> get firstScreenValidForm => CombineLatestStream.combine3(
      _oldPasswordController.itemStream,
      _passwordController.itemStream,
      repeatedPasswordField,
      (a, b, c) => true);

  @override
  void dispose() {
    repeatedPassword$.close();
    _emailController.dispose();
    _passwordController.dispose();
  }

  doSendEmailWithNewPassword() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    var resp = await _authService.restorePassword(_emailController.rawValue);
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();

    if (resp.status == GenericResponseStatus.COMPLETED) {
      _gotoEnterNewPassScreen();
      _showSendEmailSuccess();
    } else {
      _showErrorMessage(resp);
    }
  }

  doChangePassword() async {
    GetIt.I<PoolServices>().loadingService.showLoadingScreen();

    var resp = await _authService.changePassword(
      _emailController.rawValue,
      _oldPasswordController.rawValue,
      _passwordController.rawValue,
    );
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();

    if (resp.status == GenericResponseStatus.COMPLETED) {
      Get.back();
      _showOkMessage();
    } else {
      _showErrorMessage(resp);
    }
  }

  showNoEmailError() {
    GetIt.I<PoolServices>()
        .loadingService
        .showErrorSnackbar('Ingresa un correo electrónico');
  }

  showNoPasswordError() {
    GetIt.I<PoolServices>()
        .loadingService
        .showErrorSnackbar('Ingresa los campos requeridos');
  }

  gotoSigninPage() {
    Get.toNamed(NavigationRoute.SIGNIN);
  }

  _gotoEnterNewPassScreen() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  void _showErrorMessage(GenericResponse resp) {
    String errorMessage;
    switch (resp.errorStatus) {
      case 506:
        errorMessage =
            'La contraseña actual no es correcta. Intenta nuevamente.';
        break;
      case 424:
        errorMessage =
            'Tu cuenta está asociada con Facebook. Inicia sesión con el botón Continuar con Facebook';
        break;
      case 425:
        errorMessage =
            'Tu cuenta está asociada con Google. Inicia sesión con el botón Continuar con Google';
        break;
      case 428:
        errorMessage = 'Correo electrónico no registrado.';
        break;
      default:
        errorMessage = 'Ha ocurrido un error inesperado.';
        break;
    }
    GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
  }

  void _showOkMessage() {
    _showMessage(
      "Cambio de contraseña exitosa",
      "Tu contraseña ha sido cambiado, ingresa y disfruta con Futgolazo.",
    );
  }

  void _showSendEmailSuccess() {
    _showMessage(
      "Contraseña temporal generada",
      "Una contraseña temporal se ha enviado a tu correo electrónico.",
    );
  }

  void _showMessage(String title, String desc) {
    final theme = GetIt.I<PoolServices>().futgolazoMainTheme;
    Get.snackbar(
      title,
      desc,
      borderWidth: 4,
      duration: Duration(milliseconds: 4000),
      colorText: theme.getColorsTheme.getColorBackground,
      borderColor: theme.getColorsTheme.getColorOnPrimary,
      backgroundColor: theme.getColorsTheme.getColorSurface,
    );
  }
}
