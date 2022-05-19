import 'dart:math';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/enums/terms_politics.enum.dart';
import 'package:futgolazo/src/components/widget/rive_button.dart';
import 'package:futgolazo/src/components/halo_image/halo_image.dart';
import 'package:futgolazo/src/components/widget/checkbox_circular.dart';

class TermsConditionsScreen extends StatefulWidget {
  final VoidCallback onEnterToApp;

  const TermsConditionsScreen({
    Key key,
    this.onEnterToApp,
  }) : super(key: key);

  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final futgolazoMainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;
  final fontSize = GetIt.I<PoolServices>().futgolazoMainTheme.getFontSize;
  final responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive;

  bool _userIsAdult;
  bool _acceptTermsConditions;

  @override
  void initState() {
    super.initState();
    _userIsAdult = false;
    _acceptTermsConditions = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _logoTrivia(),
                _termAndConditionsForm(),
                _playButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoTrivia() {
    return Hero(
      tag: 'logo_trivia',
      child: Container(
        height: responsive.hp(30),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            OverflowBox(
              maxHeight: responsive.hp(50),
              child: HaloImage(),
            ),
            Image.asset(
              'assets/trivia/Logo_trivia.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _playButton() {
    return Hero(
      tag: 'button',
      flightShuttleBuilder: _flightShuttleBuilder,
      child: RiveButton(
        buttonText: 'Entrar',
        responsive: responsive,
        onTapButton: _userIsAdult && _acceptTermsConditions
            ? () => widget.onEnterToApp()
            : null,
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  _termAndConditionsForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: responsive.hp(4)),
      decoration: BoxDecoration(
        color: futgolazoMainTheme.getColorsTheme.getColorOnBackground,
        borderRadius: BorderRadius.circular(responsive.ip(2)),
        border: Border.all(
          color: futgolazoMainTheme.getColorsTheme.getColorOnPrimary,
          width: responsive.ip(0.2),
        ),
      ),
      height: responsive.hp(25),
      width: responsive.wp(80),
      padding: EdgeInsets.all(responsive.wp(4)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              CheckBoxCircular(
                radio: responsive.ip(1.8),
                value: _acceptTermsConditions,
                onChanged: (bool value) {
                  GetIt.I<PoolServices>().audioService.playRandomButton();
                  setState(() {
                    _acceptTermsConditions = value;
                  });
                },
              ),
              SizedBox(
                width: responsive.wp(5),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'Acepto estos ',
                    style: styleCustom,
                    children: [
                      TextSpan(
                        text: 'Términos y Condiciones',
                        style: styleCustom.copyWith(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _navigate(TermsPoliticsEnum.TERMS),
                      ),
                      TextSpan(text: ' y las ', style: styleCustom),
                      TextSpan(
                        text: 'Políticas de Privacidad.',
                        style: styleCustom.copyWith(
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _navigate(TermsPoliticsEnum.POLITICS),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsive.hp(5),
          ),
          Row(
            children: <Widget>[
              CheckBoxCircular(
                radio: responsive.ip(1.8),
                value: _userIsAdult,
                onChanged: (bool value) {
                  GetIt.I<PoolServices>().audioService.playRandomButton();
                  setState(() {
                    _userIsAdult = value;
                  });
                },
              ),
              SizedBox(
                width: responsive.wp(5),
              ),
              Expanded(
                child: Text('Tengo más de 18 años.', style: styleCustom),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle get styleCustom => fontSize
      .bodyText1(
        color: futgolazoMainTheme.getColorsTheme.getColorSurfaceVariant,
      )
      .copyWith(
        fontSize: max(responsive.ip(1.8), 12.0),
      );

  _navigate(TermsPoliticsEnum type) {
    Get.toNamed(NavigationRoute.TERMS_POLITICS, arguments: type);
  }
}
