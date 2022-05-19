import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:get/get.dart';

import '../../../bloc/signup/signup_bloc.dart';
import '../../../bloc/base/validation_item_block.dart';
import '../../../components/password/password_input.dart';
import '../../../components/widget/checkbox_circular.dart';
import '../../../components/widget/custom_text_field.dart';
import '../../../components/widget/button_shadow_rounded.dart';
import '../../../components/custom_scafold/statefull_custom.dart';
import '../../../components/container_default/contain_default.dart';

class FirstScreenUserRegister extends StateFullCustom {
  final SignUpBloc signupBloc;

  FirstScreenUserRegister({this.signupBloc}) : super();

  @override
  _FirstScreenUserRegisterState createState() =>
      _FirstScreenUserRegisterState();
}

class _FirstScreenUserRegisterState extends State<FirstScreenUserRegister>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.responsive.wp(5)),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTitleForm(),
              SizedBox(
                height: widget.responsive.hp(5),
              ),
              ContainerDefault(
                child: Column(
                  children: <Widget>[
                    _genericInput(widget.signupBloc.emailField, 'Email'),
                    SizedBox(
                      height: widget.responsive.hp(2),
                    ),
                    _createPassword(),
                    SizedBox(
                      height: widget.responsive.hp(2),
                    ),
                    _createRepeatPassword(),
                    SizedBox(
                      height: widget.responsive.hp(5),
                    ),
                    _buildCheckBox(
                      'Declaro ser mayor de 18 años',
                      widget.signupBloc.acceptAdultController,
                    ),
                    SizedBox(
                      height: widget.responsive.hp(1.5),
                    ),
                    _buildCheckTermAndPolicies(
                      widget.signupBloc.acceptConditionController,
                    ),
                    SizedBox(
                      height: widget.responsive.hp(1.5),
                    ),
                    _buildCheckBox(
                        'Acepto recibir novedades y promociones por email',
                        widget.signupBloc.acceptNotiMail),
                    SizedBox(
                      height: widget.responsive.hp(5),
                    ),
                    _createButton()
                  ],
                ),
              ),
              _buildLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckTermAndPolicies(ValidationItemBloc stream) {
    String text = 'Leí y acepto los ',
        termText = 'Términos y Condiciones',
        politicsText = 'Políticas de privacidad';
    return StreamBuilder(
      stream: stream.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CheckBoxCircular(
              value: snapshot.data ?? false,
              radio: widget.responsive.ip(1.6),
              onChanged: (status) {
                print('value checkbox ' + status.toString());
                if (status) {
                  stream.addDataToStream(status);
                } else {
                  stream.addDataToStream(false);
                }
              },
              border: true,
            ),
            SizedBox(
              width: widget.responsive.wp(4),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                    ),
                    TextSpan(
                      text: termText,
                      style: widget.fontSize
                          .bodyText2()
                          .copyWith(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _navigate(TermsPoliticsEnum.TERMS);
                        },
                    ),
                    TextSpan(
                      text: ' y las ',
                    ),
                    TextSpan(
                      text: politicsText,
                      style: widget.fontSize
                          .bodyText2()
                          .copyWith(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _navigate(TermsPoliticsEnum.POLITICS);
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildCheckBox(String text, ValidationItemBloc stream) {
    return StreamBuilder(
      stream: stream.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CheckBoxCircular(
              value: snapshot.data ?? false,
              radio: widget.responsive.ip(1.6),
              onChanged: (status) {
                print('value checkbox ' + status.toString());
                if (status) {
                  stream.addDataToStream(status);
                } else {
                  stream.addDataToStream(false);
                }
              },
              border: true,
            ),
            SizedBox(
              width: widget.responsive.wp(4),
            ),
            Expanded(
              child: Text(text),
            )
          ],
        );
      },
    );
  }

  Widget _buildTitleForm() {
    return Container(
      child: Text(
        '¡Crea tu contraseña y empieza a jugar!',
        style: widget.fontSize
            .headline4(
              color: widget.colorsTheme.getColorOnButton,
            )
            .copyWith(
              fontSize: widget.responsive.ip(2.6),
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _createButton() {
    return StreamBuilder(
      stream: widget.signupBloc.firstScreenValidForm,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          width: double.infinity,
          child: Text(
            'Siguiente',
            style: widget.fontSize.bodyText1(
              color: widget.colorsTheme.getColorOnSecondary,
            ),
          ),
          onPressed:
              snapshot.hasData ? widget.signupBloc.gotoSecondScreen : null,
        );
      },
    );
  }

  Widget _genericInput(ValidationItemBloc<String> fieldBloc, String labelText) {
    return StreamBuilder(
      stream: fieldBloc.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomTextField(
          labelText: labelText,
          onChanged: fieldBloc.addDataToStream,
          errorText: snapshot.error,
          hintText: 'Ingresa tu email',
        );
      },
    );
  }

  Widget _createPassword() {
    return Container(
      child: PasswordInput(
        passwordStream: widget.signupBloc.passwordField.itemStream,
        setPasswordFunct: widget.signupBloc.passwordField.addDataToStream,
        hintText: 'Crea una contraseña',
      ),
    );
  }

  Widget _createRepeatPassword() {
    return Container(
      key: Key('value'),
      child: PasswordInput(
        labelText: 'Repetir contraseña',
        hintText: 'Repite la contraseña',
        passwordStream: widget.signupBloc.repeatedPasswordField,
        setPasswordFunct: widget.signupBloc.repeatedPassword$.sink.add,
      ),
    );
  }

  // COMENTADO  HASTA QUE SE DEFINA LOS TERMINOS Y CONDICIONES
  _navigate(TermsPoliticsEnum type) {
    Get.toNamed(NavigationRoute.TERMS_POLITICS, arguments: type);
  }

  _buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: widget.responsive.ip(3)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Ya tengo cuenta',
              style: widget.fontSize.headline6().copyWith(
                  color: widget.colorsTheme.getColorOnButton,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context)
                      .pushReplacementNamed(NavigationRoute.SIGNIN);
                },
            )
          ],
        ),
      ),
    );
  }

  // COMENTADO POR SI SE NECESITA UN BOTON PARA IR A LOGIN
  // Widget _gotoSigninPage(BuildContext context) {
  //   return FlatButton(
  //     child: Text(
  //       'Ya tengo cuenta',
  //       style: widget.fontSize.headline5().copyWith(
  //             decoration: TextDecoration.underline,
  //           ),
  //     ),
  //     textColor: Colors.white,
  //     onPressed: () =>
  //         Navigator.of(context).pushReplacementNamed(NavigationRoute.SIGNIN),
  //   );
  // }
}
