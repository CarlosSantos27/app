import 'package:flutter/material.dart';
import 'package:futgolazo/src/dialog/base/custom_dialog_base.dart';
import 'package:get/get.dart';

class PurchaseOkDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        body: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Compra exitosa'),
          SizedBox(height: 12.0),
          OutlineButton(
            borderSide:
                BorderSide(color: Color.fromRGBO(7, 76, 127, 1), width: 2),
            onPressed: () {
              Get.back();
            },
            child: Container(
              child: Text('ACEPTAR'),
            ),
          ),
        ],
      ),
    ));
  }
}
