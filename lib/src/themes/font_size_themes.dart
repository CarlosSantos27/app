import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class FontSizeThemes {
  TextTheme _currentTextTheme;

  final Color normalColor;
  final Responsive responsive;

  FontSizeThemes({
    this.responsive,
    this.normalColor,
  }) {
    _currentTextTheme = TextTheme(
      headline1: headline1(color: normalColor),
      headline2: headline2(color: normalColor),
      headline3: headline3(color: normalColor),
      headline4: headline4(color: normalColor),
      headline5: headline5(color: normalColor),
      headline6: headline6(color: normalColor),
      bodyText1: bodyText1(color: normalColor),
      bodyText2: bodyText2(color: normalColor),
      subtitle1: subtitle1(color: normalColor),
      subtitle2: subtitle2(color: normalColor),
      button: button(color: normalColor),
      caption: caption(color: normalColor),
      overline: overline(color: normalColor),
    );
  }

  TextTheme get getTextTheme => _currentTextTheme;

  TextStyle headline1({Color color = Colors.white}) {
    print(responsive.ip(10));
    return TextStyle(
      fontSize: responsive.ip(6),
      color: color,
      letterSpacing: 1.2,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle headline2({Color color = Colors.white}) {
    return TextStyle(
      fontSize: responsive.ip(5),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle headline3({Color color = Colors.white}) {
    return TextStyle(
      fontSize: responsive.ip(4),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle headline4({Color color = Colors.white}) {
    return TextStyle(
      fontSize: responsive.ip(3),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle headline5({Color color = Colors.white}) {
    return TextStyle(
      fontSize: responsive.ip(2.3),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle headline6({Color color = Colors.white}) {
    return TextStyle(
      fontSize: responsive.ip(2),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle bodyText1({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(2), 15.0),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle bodyText2({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(1), 14.0),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle subtitle1({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(2), 16.0),
      color: color,
    );
  }

  TextStyle subtitle2({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(1.5), 14.0),
      color: color,
    );
  }

  TextStyle button({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(2), 12.0),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle mainButton({Color color = Colors.white}) {
    return button().copyWith(fontSize: responsive.ip(4));
  }

  TextStyle overline({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(1.5), 12.0),
      color: color,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle caption({Color color = Colors.white}) {
    return TextStyle(
      fontSize: max(responsive.ip(1), 10.0),
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}
