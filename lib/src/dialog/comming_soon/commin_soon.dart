import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/dialog/base/custom_dialog_base.dart';
import 'package:futgolazo/src/components/widget/button_border_double.dart';

class CommingSoonDialog extends StatelessWidget {
  final VoidCallback closePopupCallback;
  final _futgolazoMainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  CommingSoonDialog({
    Key key,
    this.closePopupCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        body: Container(
      color:
          _futgolazoMainTheme.getColorsTheme.getColorBackground.withOpacity(.8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _futgolazoMainTheme.getResponsive.wp(5)),
        width: _futgolazoMainTheme.getResponsive.wp(100),
        height: _futgolazoMainTheme.getResponsive.hp(100) -
            Get.mediaQuery.padding.top,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _futgolazoMainTheme.getResponsive.wp(7),
                  vertical: _futgolazoMainTheme.getResponsive.hp(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: _futgolazoMainTheme.getColorsTheme.getColorOnError,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/common/CascaritaEstamosTrabajando.png',
                      height: _futgolazoMainTheme.getResponsive.hp(30),
                    ),
                    SizedBox(
                      height: _futgolazoMainTheme.getResponsive.hp(3),
                    ),
                    _messageText(),
                    SizedBox(
                      height: _futgolazoMainTheme.getResponsive.hp(3),
                    ),
                    _closeButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _messageText() {
    return Text(
      'Estamos Trabajando',
      textAlign: TextAlign.center,
      style: _futgolazoMainTheme.getFontSize.headline4(
        color: _futgolazoMainTheme.getColorsTheme.getColorBackground,
      ),
    );
  }

  Widget _closeButton() {
    return ButtonBorderDouble.green(
      child: Text(
        'Ok'.toUpperCase(),
        style: _futgolazoMainTheme.getFontSize.button(),
      ),
      ontap: closePopupCallback,
    );
  }
}
