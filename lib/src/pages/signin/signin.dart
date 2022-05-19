import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/singin/signin_bloc.dart';
import 'package:futgolazo/src/components/container_default/contain_default.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:futgolazo/src/components/futgolazo_scaffold/futgolazo_scaffold.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:futgolazo/src/components/widget/custom_text_field.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:futgolazo/src/networking/generic_response.dart';
import 'package:futgolazo/src/pages/simple_signin/terms_conditions_page/terms_politics_page.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SignIn extends StateFullCustom {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SigninBloc singInBloc;
  String username;
  bool _passwordVisible;
  @override
  void initState() {
    this._passwordVisible = true;
    singInBloc = new SigninBloc();
    username = '';
    super.initState();
  }

  @override
  void dispose() {
    singInBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _verifyExit,
      child: FutgolazoScaffold(
        withBackButton: true,
        resizeToAvoidBottomPadding: true,
        body: _loginForm(),
      ),
    );
  }

  Future<bool> _verifyExit() async {
    if (username != null && username.isNotEmpty) {
      setState(() {
        username = null;
      });
      return false;
    }
    return true;
  }

  Widget _loginForm() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
            _buildLogo(),
            SizedBox(height: widget.responsive.hp(1.3)),
            _buildUserNameText(),
            SizedBox(height: widget.responsive.hp(3.3)),
            _buildCardForm(),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: widget.responsive.hp(3.3)),
              child: Column(
                children: [
                  _buildDontHaveAccount(),
                  _buildPrivacyPolicy(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: widget.responsive.hp(20),
      child: Image.asset(
        'assets/common/logo.png',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildUserNameText() {
    return Container(
      width: widget.responsive.wp(50.0),
      child: Text(
        (username != null && username.isNotEmpty)
            ? username
            : 'Demuestra que tú sabes.',
        style: widget.textTheme.bodyText1
            .copyWith(color: widget.colorsTheme.getColorOnButton),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCardForm() {
    return SizedBox(
      width: widget.responsive.wp(90.0),
      child: ContainerDefault(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmail(singInBloc),
            SizedBox(height: widget.responsive.hp(3.3)),
            if (username != null && username.isNotEmpty)
              _buildPasswordSection(),
            if (username == null || username.isEmpty) _buildLoginOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStrem,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          key: Key('emailTxt'),
          keyBoardType: TextInputType.emailAddress,
          labelText: 'Email',
          hintText: 'Ingresa tu email',
          readOnly: (username != null && username.isNotEmpty),
          errorText: snapshot.error,
          onChanged: bloc.setEmail,
        );
      },
    );
  }

  _buildLoginOptions() {
    return Column(
      children: [
        _buildButton(singInBloc),
        Padding(
          padding: EdgeInsets.symmetric(vertical: widget.responsive.hp(1.1)),
          child: Text(
            'O',
            style: widget.textTheme.bodyText2.copyWith(
              color: widget.colorsTheme.getColorOnButton,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildFacebookButton(),
        SizedBox(height: widget.responsive.hp(2.0)),
        if (Platform.isAndroid) _buildGoogleButton(),
        if (Platform.isIOS) _buildAppleButton(),
      ],
    );
  }

  Widget _buildButton(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStrem,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return ButtonShadowRounded(
          width: double.infinity,
          child: Text(
            'Continuar con email',
            style: widget.fontSize.bodyText1().copyWith(
                  fontStyle: FontStyle.normal,
                  color: widget.colorsTheme.getColorOnSecondary,
                ),
          ),
          onPressed: (snapshot.hasData && snapshot.data.isNotEmpty)
              ? _verifyEmailLogin
              : null,
        );
      },
    );
  }

  Widget _buildFacebookButton() {
    return ButtonShadowRounded(
      width: double.infinity,
      background: widget.colorsTheme.getColorOnButton,
      child: Text(
        'Ingresar con Facebook',
        style: widget.fontSize.bodyText1().copyWith(
              fontStyle: FontStyle.normal,
              color: widget.colorsTheme.getColorOnSecondary,
            ),
      ),
      onPressed: _signInWithFacebook,
    );
  }

  Widget _buildGoogleButton() {
    return ButtonShadowRounded(
      width: double.infinity,
      background: Color.fromRGBO(235, 132, 166, 1.0),
      child: Text(
        'Ingresar con Google',
        style: widget.fontSize.bodyText1().copyWith(
              fontStyle: FontStyle.normal,
              color: widget.colorsTheme.getColorOnSecondary,
            ),
      ),
      onPressed: _signInWithGoogle,
    );
  }

  Widget _buildAppleButton() {
    return ButtonShadowRounded(
      width: double.infinity,
      background: Colors.white,
      child: Text(
        'Ingresar con APPLE',
        style: widget.fontSize.bodyText1().copyWith(color: Colors.black),
        textAlign: TextAlign.left,
      ),
      onPressed: _signInWithApple,
    );
  }

  Widget _buildPrivacyPolicy() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Política de privacidad',
            style: widget.fontSize.bodyText2().copyWith(
                  color: widget.colorsTheme.getColorOnButton,
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _showTermsPage(TermsPoliticsEnum.POLITICS);
              },
          ),
        ],
      ),
    );
  }

  Widget _buildDontHaveAccount() {
    return Container(
      margin: EdgeInsets.only(
          top: widget.responsive.ip(0.9), bottom: widget.responsive.ip(0.8)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '¿No Tienes Cuenta? Registrate',
              style: widget.fontSize.headline6().copyWith(
                  color: widget.colorsTheme.getColorOnButton,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context)
                      .pushReplacementNamed(NavigationRoute.SIGNUP);
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      children: [
        _buildPassword(singInBloc),
        Padding(
          padding: EdgeInsets.symmetric(vertical: widget.responsive.hp(3.5)),
          child: _buildForgotMyPassword(),
        ),
        _buildLoginButton(singInBloc),
      ],
    );
  }

  Widget _buildPassword(SigninBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStrem,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          hintText: 'Contraseña',
          obscureText: this._passwordVisible,
          errorText: snapshot.error,
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              this._passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          onChanged: bloc.setPassword,
        );
      },
    );
  }

  Widget _buildForgotMyPassword() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'Olvidé mi contraseña',
          style: widget.fontSize.bodyText2().copyWith(
              color: widget.colorsTheme.getColorOnButton,
              decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () =>
                Navigator.pushNamed(context, NavigationRoute.RECOVER_PASSWORD),
        )
      ]),
    );
  }

  Widget _buildLoginButton(SigninBloc bloc) {
    return StreamBuilder(
        stream: bloc.validForm,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ButtonShadowRounded(
              width: double.infinity,
              child: Text(
                'Ingresar',
                style: widget.fontSize
                    .bodyText1()
                    .copyWith(fontStyle: FontStyle.normal),
              ),
              onPressed: (snapshot.hasData && snapshot.data)
                  ? () => _login(context, bloc)
                  : null);
        });
  }

  _login(BuildContext context, SigninBloc bloc) async {
    await singInBloc.doLogin();
  }

  _verifyEmailLogin() async {
    username = await singInBloc.validateEmailLogin();
    setState(() {});
  }

  _signInWithGoogle() async {
    final resp = await GetIt.I<PoolServices>().authService.signInWithGoogle();
    _signFlow(resp);
  }

  _signInWithFacebook() async {
    final resp = await GetIt.I<PoolServices>().authService.signWithFacebook();
    _signFlow(resp);
  }

  _signInWithApple() async {
    final resp = await GetIt.I<PoolServices>().authService.signWithAppleId();
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
      _setErrorText(genericResponse.errorStatus, genericResponse.message);
    }
  }

  void _setErrorText(int errorStatus, String error) {
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
      case 415:
        errorMessage =
            'Tu correo ya está asociado a una cuenta, presiona el botón REGISTRARME CON APPLE para iniciar sesión.';
        break;
      case 1:
        errorMessage = 'Ha ocurrido un error interno con google';
        print('Error interno de google');
        break;
      case 2:
        errorMessage = 'Ha ocurrido un error interno con Facebook';
        print('Error interno de facebook');
        break;
      case 3:
        errorMessage = error ?? 'Ha ocurrido un error interno con Apple';
        break;
      case 0:
        return;
    }
    GetIt.I<PoolServices>().loadingService.showErrorSnackbar(errorMessage);
  }

  _showTermsPage(TermsPoliticsEnum termsPoliticsEnum) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return TermsPoliticsPage(termsPoliticsEnum);
      }),
    );
  }
}
