import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/bloc/mini_card/mini_card_bloc.dart';
import 'package:futgolazo/src/dialog/base/custom_dialog_base.dart';
import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class SendCardAsGuestPopup extends StateLessCustom {
  final MiniCardBloc miniCardBloc;
  final Function onAcceptCallback;

  SendCardAsGuestPopup({
    @required this.miniCardBloc,
    @required this.onAcceptCallback,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      insetPadding: EdgeInsets.all(
        responsive.ip(4),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: colorsTheme.getColorBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('No te has registrado'),
            SizedBox(
              height: responsive.hp(3),
            ),
            Text(
              'Regístrate y tu Mini cartilla estará lista para que la envíes',
              style: textTheme.button.copyWith(
                color: colorsTheme.getColorOnPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlineButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Container(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: colorsTheme.getColorOnPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: responsive.wp(3),
                ),
                ButtonShadowRounded(
                  onPressed: () {
                    Get.back();
                    this.onAcceptCallback();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.ip(.5),
                      horizontal: responsive.ip(1.5),
                    ),
                    child: Text(
                      'ACEPTAR',
                      style: textTheme.button.copyWith(
                        color: colorsTheme.getColorSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
