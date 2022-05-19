import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/font_size_themes.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/components/widget/button_border_single_color.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/futgolazo_scaffold.dart';
import 'package:futgolazo/src/components/button_text_redirect/button_text_redirect.dart';

class SignupButtonsMenu extends StatelessWidget {
  final mainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  Responsive get responsive => mainTheme.getResponsive;
  FontSizeThemes get fontSize => mainTheme.getFontSize;

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: Container(
        child: _mainContent(),
      ),
    );
  }

  Widget _mainContent() {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo_trivia',
                child: Container(
                  width: responsive.wp(50),
                  child: Image.asset(
                    'assets/trivia/trivia_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: responsive.hp(2.6)),
              _drawButton(
                color: Colors.redAccent,
                label: 'Registrarme CON GOOGLE'.toUpperCase(),
                f: _signInWithGoogle,
                icon: Icons.ac_unit,
              ),
              SizedBox(height: responsive.hp(2.6)),
              _drawButton(
                color: Colors.blueAccent,
                label: 'Registrarme CON FACEBOOK'.toUpperCase(),
                f: _signInWithFacebook,
                icon: Icons.access_alarm,
              ),
              SizedBox(height: responsive.hp(2.6)),
              _drawButton(
                color: Colors.green,
                label: 'Registrarme CON MI CORREO'.toUpperCase(),
                f: () => Get.toNamed(NavigationRoute.SIGNUP),
                icon: Icons.accessibility,
              ),
              SizedBox(height: responsive.hp(4)),
              ButtonTextRedirect(
                routeRedirect: NavigationRoute.SIGNIN_MENU,
                textButton: 'Ingresar',
                labelButton: '¿Ya tienes cuenta?',
                pushedRoute: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _drawButton({Color color, String label, Function f, IconData icon}) {
    return ButtonBorderSingleColor(
      ontap: f,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(
              icon,
              color: mainTheme.getColorsTheme.getColorSurface,
            ),
            margin: EdgeInsets.only(left: responsive.wp(2)),
          ),
          Expanded(
            child: Text(
              label,
              style: fontSize.bodyText1(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      width: responsive.wp(84),
      height: responsive.hp(6),
    );
  }

  _signInWithGoogle() async {
    final resp = await GetIt.I<PoolServices>().authService.signInWithGoogle();
    _signFlow(resp);
  }

  _signInWithFacebook() async {
    final resp = await GetIt.I<PoolServices>().authService.signWithFacebook();
    _signFlow(resp);
  }

  void _signFlow(GenericResponse genericResponse) {
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      if (genericResponse.data['acceptTerms']) {
        Get.offAllNamed(NavigationRoute.HOME);
      } else {
        Get.offNamed(NavigationRoute.ACCEPT_REQUIREMENTS);
      }
    } else {
      _setErrorText(genericResponse.errorStatus);
    }
  }

  void _setErrorText(int errorStatus) {
    String errorMessage = '';
    switch (errorStatus) {
      case 429:
        errorMessage =
            'Tu correo está asociado a una cuenta Facebook, presiona el botón REGISTRARME CON FACEBOOK para iniciar sesión.';
        print('Usuario en Facebook');
        break;
      case 431:
        errorMessage =
            'Tu correo está asociado a una cuenta Google, presiona el botón REGISTRARME CON GOOGLE para iniciar sesión.';
        print('Usuario en Google');
        break;
      case 451:
        errorMessage =
            'Tu correo ya está asociado a una cuenta, presiona el botón REGISTRARME CON MI CORREO para iniciar sesión.';
        print('Usuario normal');
        break;
      case 1:
        errorMessage = 'Ha ocurrido un error interno con google';
        print('Error interno de google');
        break;
      case 2:
        errorMessage = 'Ha ocurrido un error interno con Facebook';
        print('Error interno de facebook');
        break;
      case 0:
        return;
    }
    GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
  }
}
