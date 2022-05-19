import 'package:futgolazo/src/components/container_default/contain_default.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:futgolazo/src/components/widget/custom_text_field.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/bloc/signup/signup_bloc.dart';
import 'package:futgolazo/src/themes/font_size_themes.dart';

class UserCodeValidation extends StateFullCustom {
  final SignUpBloc signupBloc;

  UserCodeValidation({Key key, this.signupBloc}) : super(key: key);

  @override
  _UserCodeValidationState createState() => _UserCodeValidationState();
}

class _UserCodeValidationState extends State<UserCodeValidation> {
  final _theme = GetIt.I<PoolServices>().futgolazoMainTheme;

  Responsive get responsive => _theme.getResponsive;
  FontSizeThemes get fontSize => _theme.getFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.responsive.wp(5)),
      child: Center(
        child: SingleChildScrollView(
          child: contentForm(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Verifica tu cuenta',
                        style: fontSize.headline3(
                          color: _theme.getColorsTheme.getColorOnButton,
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(5),
                      ),
                    ],
                  ),
                ),
                ContainerDefault(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Ingresa el código que hemos enviado al telefóno.',
                        textAlign: TextAlign.center,
                        style: fontSize.bodyText2(
                            color: _theme.getColorsTheme.getColorOnButton),
                      ),
                      SizedBox(
                        height: responsive.hp(5),
                      ),
                      _buildInputValidationCode(),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: responsive.wp(8)),
                        child: Text(
                          'Una vez verificada tu cuenta podrás empezar a jugar Futgolazo.',
                          style: fontSize.bodyText2(
                              color: _theme.getColorsTheme.getColorOnButton),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _createButton(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildResendOtp(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contentForm({child}) {
    return Container(
      child: child,
    );
  }

  Widget _createButton() {
    return StreamBuilder(
      stream: widget.signupBloc.userValidationCodeController.itemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ButtonShadowRounded(
          width: widget.responsive.wp(50),
          child: Text(
            'Verificar',
            style: fontSize.button(),
          ),
          onPressed: snapshot.hasData
              ? () => widget.signupBloc.otpValidation(context)
              : null,
        );
      },
    );
  }

  Widget _buildInputValidationCode() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(8)),
      child: CustomTextField(
        labelText: 'Código',
        hintText: 'Ingresa el código',
        maxLength: 6,
        onChanged:
            widget.signupBloc.userValidationCodeController.addDataToStream,
      ),
    );
  }

  Widget _buildResendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '¿No llega tu código?',
          style: fontSize.bodyText2(
            color: _theme.getColorsTheme.getColorOnButton,
          ),
        ),
        SizedBox(
          width: widget.responsive.wp(5),
        ),
        ButtonShadowRounded(
          onPressed: () => widget.signupBloc.resendOtp(context),
          child: Text(
            "Re-enviar código",
            style: widget.fontSize.headline6().copyWith(
                  fontSize: widget.responsive.ip(1.8),
                  color: widget.colorsTheme.getColorOnButton,
                ),
          ),
        ),
      ],
    );
  }
}
