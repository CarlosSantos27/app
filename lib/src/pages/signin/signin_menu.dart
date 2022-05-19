import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../utils/responsive.dart';
import '../../services/pool_services.dart';
import '../../themes/font_size_themes.dart';
import '../../networking/generic_response.dart';
import '../../components/futgolazo_scaffold/futgolazo_scaffold.dart';
import 'package:futgolazo/src/components/widget/button_border_single_color.dart';
import 'package:futgolazo/src/components/button_text_redirect/button_text_redirect.dart';

class SigninMenu extends StatelessWidget {
  final mainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  Responsive get responsive => mainTheme.getResponsive;
  FontSizeThemes get fontSize => mainTheme.getFontSize;

  @override
  Widget build(BuildContext context) {
    return FutgolazoScaffold(
      body: _mainContent(),
    );
  }

  Widget _mainContent() {
    return Center(
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
            label: 'INGRESAR CON GOOGLE',
            f: _signInWithGoogle,
            icon: Icons.ac_unit,
          ),
          SizedBox(height: responsive.hp(2.6)),
          _drawButton(
            color: Colors.blueAccent,
            label: 'INGRESAR CON FACEBOOK',
            f: _signInWithFacebook,
            icon: Icons.access_alarm,
          ),
          SizedBox(height: responsive.hp(2.6)),
          _drawButton(
            color: Colors.green,
            label: 'INGRESAR CON MI CORREO',
            f: () => Get.toNamed(NavigationRoute.SIGNIN),
            icon: Icons.accessibility,
          ),
          SizedBox(height: responsive.hp(4)),
          ButtonTextRedirect(
            routeRedirect: NavigationRoute.SIGNUP_BUTTONS_MENU,
            textButton: 'Registrarme',
            labelButton: '¿Aún no tienes cuenta?',
            pushedRoute: false,
          ),
        ],
      ),
    );
  }

  _drawButton({
    Color color,
    String label,
    Function f,
    IconData icon,
  }) {
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
              size: responsive.ip(2.8),
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
    GetIt.I<PoolServices>().loadingService.hideLoadingScreen();
    if (genericResponse.status == GenericResponseStatus.COMPLETED) {
      if (genericResponse.data['acceptTerms']) {
        Get.offAllNamed(NavigationRoute.HOME);
      } else {
        Get.offNamed(NavigationRoute.ACCEPT_REQUIREMENTS);
      }
    } else {
      _setErrorText(genericResponse.errorStatus, genericResponse.message);
    }
  }

  void _setErrorText(int errorStatus, String msm) {
    String errorMessage = '';
    switch (errorStatus) {
      case 429:
        errorMessage =
            'Tu correo está asociado a una cuenta Facebook, presiona el botón INGRESAR CON FACEBOOK para iniciar sesión.';
        break;
      case 431:
        errorMessage =
            'Tu correo está asociado a una cuenta Google, presiona el botón INGRESAR CON GOOGLE para iniciar sesión.';
        break;
      case 451:
        errorMessage =
            'Tu correo ya está asociado a una cuenta, presiona el botón INGRESAR CON MI CORREO para iniciar sesión.';
        break;
      case 2:
        errorMessage = 'Ha ocurrido un error interno con Facebook';
        break;
      case 1:
        errorMessage = 'Tenemos inconvenientes revisa tu conexión a Internet';
        break;
    }
    if (errorMessage.isNotEmpty) {
      GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
    }
  }
}
