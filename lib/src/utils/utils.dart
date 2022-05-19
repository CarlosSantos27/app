import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import '../services/pool_services.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String message) {
  final _theme = GetIt.I<PoolServices>().futgolazoMainTheme;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: _theme.getFontSize.bodyText1(
              color: _theme.getColorsTheme.getColorBackground,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Aceptar",
                style: _theme.getFontSize.bodyText2(),
              ),
              color: _theme.getColorsTheme.getColorBackground,
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

String onlyOneName(String value) {
  if (value == null) return value;
  return (value.split(' '))[0];
}

String createCryptoRandomString([int length = 32]) {
  Random _random = Random.secure();
  var values = List<int>.generate(length, (i) => _random.nextInt(256));

  return base64Url.encode(values);
}

String decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
