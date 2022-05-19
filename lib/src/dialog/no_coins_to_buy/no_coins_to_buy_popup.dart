import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/dialog/base/custom_dialog_base.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class NoCoinsToBuyPopup extends StateLessCustom {
  NoCoinsToBuyPopup();

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
            SizedBox(
              height: responsive.hp(3),
            ),
            Text('No tienes suficientes Monedas'),
            SizedBox(
              height: responsive.hp(3),
            ),
            Text(
              'Nuestra tienda pronto estará lista',
              style: textTheme.button.copyWith(
                color: colorsTheme.getColorOnPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
            OutlineButton(
              onPressed: () {
                Get.offNamed(NavigationRoute.HOME);
              },
              child: Container(
                child: Text(
                  'Ir al Inicio',
                  style: TextStyle(
                    color: colorsTheme.getColorOnPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
