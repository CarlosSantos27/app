import 'package:flutter/material.dart';

import './color_themes.dart';
import './general_themes.dart';
import './font_size_themes.dart';
import '../utils/responsive.dart';

class FutgolazoMainTheme {
  Responsive _responsive;
  ThemeData _currentTheme;
  ColorsThemes _colorsThemes;
  GeneralThemes _generalThemes;
  FontSizeThemes _fontSizeThemes;

  FutgolazoMainTheme();

  ThemeData get getTheme => _currentTheme;
  Responsive get getResponsive => _responsive;
  ColorsThemes get getColorsTheme => _colorsThemes;
  FontSizeThemes get getFontSize => _fontSizeThemes;
  GeneralThemes get generalThemes => _generalThemes;
  TextTheme get getTextTheme => _fontSizeThemes.getTextTheme;

  initialize() async {
    _colorsThemes = ColorsThemes();
    _colorsThemes.setColors();

    _responsive = Responsive();

    _generalThemes = GeneralThemes();

    _fontSizeThemes = FontSizeThemes(
      normalColor: _colorsThemes.getColorSurface,
      responsive: _responsive,
    );

    _currentTheme = ThemeData(
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: _colorsThemes.getColorBackground,
      appBarTheme: AppBarTheme(
        color: _colorsThemes.getColorPrimaryVariant,
        iconTheme: IconThemeData(color: _colorsThemes.getColorSecondary),
      ),
      colorScheme: ColorScheme.light(
        error: _colorsThemes.getColorError,
        onError: _colorsThemes.getColorOnError,
        primary: _colorsThemes.getColorPrimary,
        surface: _colorsThemes.getColorSurface,
        onSurface: _colorsThemes.getColorOnSurface,
        onPrimary: _colorsThemes.getColorOnPrimary,
        secondary: _colorsThemes.getColorSecondary,
        background: _colorsThemes.getColorBackground,
        onSecondary: _colorsThemes.getColorOnSecondary,
        onBackground: _colorsThemes.getColorOnBackground,
        primaryVariant: _colorsThemes.getColorPrimaryVariant,
        secondaryVariant: _colorsThemes.getColorSecondaryVariant,
      ),
      iconTheme: IconThemeData(
        color: _colorsThemes.getColorSecondaryVariant,
      ),
      textTheme: _fontSizeThemes.getTextTheme,
    );
  }
}
