import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../routes/routes.dart';
import '../../utils/responsive.dart';
import '../../themes/color_themes.dart';
import '../../services/pool_services.dart';
import '../../themes/font_size_themes.dart';
import '../../bloc/config/settings_bloc.dart';
import 'package:futgolazo/src/components/widget/checkbox_circular.dart';
import 'package:futgolazo/src/components/widget/button_border_double.dart';

class SettingsProfileComponent extends StatefulWidget {
  @override
  _SettingsProfileComponentState createState() =>
      _SettingsProfileComponentState();
}

class _SettingsProfileComponentState extends State<SettingsProfileComponent> {
  final _theme = GetIt.I<PoolServices>().futgolazoMainTheme;

  Responsive get _responsive => _theme.getResponsive;
  ColorsThemes get _colors => _theme.getColorsTheme;
  FontSizeThemes get _fontSize => _theme.getFontSize;

  StreamSubscription<bool> settings$;

  double heightBackDrop = 0.0;
  bool settingsVisible = false;
  Curve curve = Curves.elasticOut;
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = SettingsBloc();
    final statusSettings = GetIt.I<PoolServices>().dataService.settingsStatus;

    if (statusSettings) {
      heightBackDrop = _responsive.hp(84) - Get.mediaQuery.padding.top;
      settingsVisible = true;
    }

    settings$ = GetIt.I<PoolServices>().dataService.settings$.listen((event) {
      if (event) {
        setState(() {
          curve = Curves.elasticOut;
          heightBackDrop = _responsive.hp(84) - Get.mediaQuery.padding.top;
          settingsVisible = true;
        });
      } else {
        setState(() {
          curve = Curves.easeOutQuint;
          heightBackDrop = _responsive.hp(0);
        });
      }
    });
  }

  @override
  void dispose() {
    settings$.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        child: _backDrop(),
      ),
    );
  }

  _backDrop() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: curve,
      width: _responsive.wp(100),
      height: heightBackDrop,
      child: Stack(
        children: <Widget>[
          _bodySettings(),
        ],
      ),
    );
  }

  Widget _bodySettings() {
    return !settingsVisible
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: _responsive.wp(2),
            ),
            child: Container(
              margin: EdgeInsetsDirectional.only(top: _responsive.hp(5)),
              padding: EdgeInsets.symmetric(horizontal: _responsive.wp(5)),
              height: double.infinity,
              child: _contentFormSettings(),
            ),
          );
  }

  Widget _contentFormSettings() {
    return Stack(
      children: <Widget>[
        Container(
          height: heightBackDrop * .7,
          padding: EdgeInsets.symmetric(horizontal: _responsive.wp(3)),
          decoration: BoxDecoration(
            border: Border.all(
              width: _responsive.ip(.3),
              color: _colors.getColorSurface,
            ),
            borderRadius: BorderRadius.circular(
              _responsive.ip(3),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: _responsive.hp(1)),
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Text(
                          'Ajustes',
                          style: _fontSize.headline3(),
                          textAlign: TextAlign.center,
                        ),
                        _closeBackDrop()
                      ],
                    ),
                  ),
                  _contentOptions(),
                ],
              ),
              _sectionLogout(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contentOptions() {
    return Container(
      margin: EdgeInsets.only(top: _responsive.hp(1)),
      padding: EdgeInsets.symmetric(vertical: _responsive.hp(3)),
      height: heightBackDrop * .45,
      decoration: BoxDecoration(
          color: _colors.getColorBackground,
          borderRadius: BorderRadius.circular(_responsive.ip(2))),
      child: Column(
        children: <Widget>[
          _rowOptions(
            _colors.getColorPrimaryVariant,
            'Sonido',
            CheckBoxCircular(
              value: _settingsBloc.activeSound,
              onChanged: _settingsBloc.onSoundsMute(setState),
              radio: _responsive.ip(1.5),
              border: true,
            ),
          ),
          _rowOptions(
            Colors.transparent,
            'Notificación',
            CheckBoxCircular(
              value: _settingsBloc.activeNotification,
              onChanged: _settingsBloc.onNotificationActive(setState),
              radio: _responsive.ip(1.5),
              border: true,
            ),
          ),
          _rowOptions(
            _colors.getColorPrimaryVariant,
            'Políticas de privacidad',
            ButtonBorderDouble.green(
              ontap: () {
                GetIt.I<PoolServices>().dataService.settings(false);
                // TODO NAVEGACION A TERMINOS O POLITICAS
                // Get.toNamed(NavigationRoute.TERMS_POLITICS,
                //     arguments: TermsPoliticsEnum.POLITICS);
              },
              child: Text('Leer'),
              verticalPadding: _responsive.hp(.8),
              horizontalPadding: _responsive.wp(4),
            ),
            null,
            _responsive.hp(.7),
          ),
        ],
      ),
    );
  }

  _rowOptions(Color color, String label, Widget child,
      [double horizontalPad, double verticalPad]) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad ?? _responsive.wp(4),
        vertical: verticalPad ?? _responsive.hp(1.4),
      ),
      color: color,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(label),
          ),
          child
        ],
      ),
    );
  }

  _closeBackDrop() {
    return Positioned(
      right: 0.0,
      child: GestureDetector(
        onTap: () {
          GetIt.I<PoolServices>().dataService.settings(false);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: _responsive.wp(7),
              height: _responsive.wp(7),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _colors.getColorSurface,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(
                  _responsive.wp(5),
                ),
              ),
            ),
            Text(
              'X',
              style: _fontSize.bodyText2(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLogout() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: heightBackDrop * .31,
        // color: Colors.blue,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Positioned(
              left: 0.0,
              child: _buttonLogout(),
            ),
            _imageCharacter()
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout() {
    return Container(
      padding: EdgeInsets.only(top: _responsive.hp(2), left: _responsive.wp(4)),
      child: ButtonBorderDouble.green(
        ontap: () {
          GetIt.I<PoolServices>().authService.logout();
          Get.offNamedUntil(
              NavigationRoute.INTRO, (Route<dynamic> route) => false);
          GetIt.I<PoolServices>().dataService.settings(false);
        },
        child: Text('Salir de la APP'),
      ),
    );
  }

  Widget _imageCharacter() {
    return Positioned(
      right: _responsive.wp(5),
      child: Container(
        child: Image.asset(
          'assets/common/CascaritaAjustes.png',
          fit: BoxFit.contain,
        ),
        // height: heightBackDrop * .33,
        width: _responsive.wp(38),
      ),
    );
  }
}
