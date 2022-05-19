import 'dart:math';
import 'package:futgolazo/src/components/widget/button_border_double.dart';
import 'package:futgolazo/src/components/widget/checkbox_circular.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/themes/color_themes.dart';
import 'package:futgolazo/src/enums/coin_type.enum.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';
import 'package:futgolazo/src/themes/font_size_themes.dart';
import 'package:futgolazo/src/dialog/base/custom_dialog_base.dart';

class CoinsInfoDialog extends StatefulWidget {
  final CoinTypeEnum coinTypeEnum;

  const CoinsInfoDialog({Key key, this.coinTypeEnum}) : super(key: key);

  @override
  _CoinsInfoDialogState createState() => _CoinsInfoDialogState();
}

class _CoinsInfoDialogState extends State<CoinsInfoDialog> {
  bool _dontShowPopup;

  static FutgolazoMainTheme get _theme =>
      GetIt.I<PoolServices>().futgolazoMainTheme;

  ColorsThemes get _colors => _theme.getColorsTheme;
  Responsive get _responsive => _theme.getResponsive;
  FontSizeThemes get _fontSize => _theme.getFontSize;

  @override
  void initState() {
    _dontShowPopup =
        !GetIt.I<PoolServices>().sharedPrefsService.getShowCoinsPopup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      body: Container(
        width: _responsive.wp(80),
        margin: EdgeInsets.symmetric(horizontal: _responsive.wp(3)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: _colors.getColorOnError,
            width: _responsive.ip(.25),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                _imageContainer(),
                SizedBox(
                  height: _responsive.hp(4),
                ),
                _descriptionContainer(),
                // _shopButton(),
                _dontShowAgainCheckbox()
              ],
            ),
            _closeButton(),
          ],
        ),
      ),
    );
  }

  Widget _imageContainer() {
    return Padding(
      padding: EdgeInsets.only(
        top: _responsive.hp(3),
      ),
      child: Image.asset(
        widget.coinTypeEnum == CoinTypeEnum.GOLD_COIN
            ? 'assets/info/monerdaOroPopUp.png'
            : 'assets/info/monerdaDiamantePopUp.png',
        width: _responsive.wp(30),
      ),
    );
  }

  Widget _descriptionContainer() {
    String firtParagraph =
        'Los Balones de Diamante te permiten jugar por mejores premios y acceder a trivias y eventos exclusivos.';
    String secondParagraph = 'Los puedes adquirir en nuestra tienda.';
    if (widget.coinTypeEnum == CoinTypeEnum.GOLD_COIN) {
      firtParagraph =
          'Los Balones de Oro te permiten acceder a divertidas trivias para que pongas a prueba tus conocimientos de fútbol';
      secondParagraph =
          'Recibirás uno cada semana o puesdes adquirirlos en nuestra tienda.';
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: _responsive.hp(3),
          horizontal: _responsive.wp(6),
        ),
        child: Column(
          children: <Widget>[
            Text(
              firtParagraph,
              style: _fontSize.headline5(
                color: _colors.getColorBackground,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: _responsive.hp(1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shopButton() {
    return ButtonBorderDouble.green(
      child: Icon(
        Icons.shopping_cart,
        size: 18,
        color: _colors.getColorSurface,
      ),
      ontap: () {
        Get.back();
        Get.toNamed(NavigationRoute.SHOP);
        GetIt.I<PoolServices>().audioService.playRandomButton();
      },
    );
  }

  Widget _dontShowAgainCheckbox() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _responsive.hp(4),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckBoxCircular(
              value: _dontShowPopup,
              radio: _responsive.wp(3),
              onChanged: (bool value) {
                GetIt.I<PoolServices>().audioService.playRandomButton();
                setState(() {
                  _dontShowPopup = value;
                  GetIt.I<PoolServices>()
                      .sharedPrefsService
                      .setShowCoinsPopup(!value);
                });
              },
            ),
            SizedBox(
              width: _responsive.wp(2),
            ),
            Text(
              'No volver a mostrar este mensaje.',
              style: _fontSize
                  .bodyText1(
                    color: _colors.getColorSurfaceVariant,
                  )
                  .copyWith(
                    fontSize: max(_responsive.ip(1.4), 12.0),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _closeButton() {
    return Positioned(
      top: _responsive.hp(2),
      right: _responsive.wp(4),
      child: GestureDetector(
        onTap: () {
          Get.back();
          GetIt.I<PoolServices>().audioService.playRandomButton();
        },
        child: Container(
          width: _responsive.hp(3),
          height: _responsive.hp(3),
          child: Align(
            alignment: Alignment(0, 0),
            child: Icon(
              Icons.clear,
              size: 12,
              color: _colors.getColorSurface,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                _theme.getColorsTheme.getColorOnButton,
                _theme.getColorsTheme.getColorSurfaceVariant,
              ],
              stops: [.2, 1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
    );
  }
}
