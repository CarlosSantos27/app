import 'package:flutter/material.dart';

class ColorsThemes {
  Color _error;
  Color _onError;
  Color _primary;
  Color _surface;
  Color _onSurface;
  Color _onPrimary;
  Color _secondary;
  Color _background;
  Color _onSecondary;
  Color _onBackground;
  Color _primaryVariant;
  Color _surfaceVariant;
  Color _secondaryVariant;
  Color _backgroundVariant;

  Color _button;
  Color _onButton;
  Color _buttonVariant;

  // DEFINICION DE OTROS COLORES
  Color _backgroundDarkest;

  Color get getColorError => _error;
  Color get getColorButton => _button;
  Color get getColorOnError => _onError;
  Color get getColorPrimary => _primary;
  Color get getColorSurface => _surface;
  Color get getColorOnButton => _onButton;
  Color get getColorOnSurface => _onSurface;
  Color get getColorOnPrimary => _onPrimary;
  Color get getColorSecondary => _secondary;
  Color get getColorBackground => _background;
  Color get getColorOnSecondary => _onSecondary;
  Color get getColorOnBackground => _onBackground;
  Color get getColorButtonVariant => _buttonVariant;
  Color get getColorPrimaryVariant => _primaryVariant;
  Color get getColorSurfaceVariant => _surfaceVariant;
  Color get getColorSecondaryVariant => _secondaryVariant;
  Color get getColorBackgroundVariant => _backgroundVariant;

  
  Color get getColorBackgroundDarkest => _backgroundDarkest;

  void setColors() {
    _error = Color(0xFFFF0000);
    _button = Color(0xFF183162);
    _onError = Color(0xFFFF0000);
    _primary = Color(0xFF183162);
    _surface = Color(0xFFFFFFFF);
    _onButton = Color(0xFF84A6EB);
    _onSurface = Color(0xFF31549B);
    _onPrimary = Color(0xFFB9CCF4);
    _secondary = Color(0xFF24427F);
    _background = Color(0xFF0F2043);
    _onSecondary = Color(0xFFDCE6F9);
    _onBackground = Color(0xFFFFEF0A);
    _buttonVariant = Color(0xFFFFCE0A);
    _surfaceVariant = Color(0xFFFF9D0A);
    _primaryVariant = Color(0xFFFFCE0A);
    _secondaryVariant = Color(0xFFEA7C0F);
    _backgroundVariant = Color(0xFF2DDD68);


    _backgroundDarkest=Color(0xff000C23);
  }
}
