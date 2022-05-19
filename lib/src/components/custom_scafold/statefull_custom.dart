import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../themes/color_themes.dart';
import '../../themes/general_themes.dart';
import '../../services/pool_services.dart';
import '../../themes/font_size_themes.dart';
export '../futgolazo_scaffold/futgolazo_scaffold.dart';

abstract class StateFullCustom extends StatefulWidget {
  final Key key;

  final TextTheme _textTheme;
  final Responsive _responsive;
  final ColorsThemes _colorsThemes;
  final GeneralThemes _generalThemes;
  final FontSizeThemes _fontSizeThemes;

  StateFullCustom({
    this.key,
  })  : _responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive,
        _fontSizeThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.getFontSize,
        _colorsThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.getColorsTheme,
        _generalThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.generalThemes,
        _textTheme = GetIt.I<PoolServices>().futgolazoMainTheme.getTextTheme,
        super(
          key: key,
        );

  TextTheme get textTheme => _textTheme;
  Responsive get responsive => _responsive;
  ColorsThemes get colorsTheme => _colorsThemes;
  FontSizeThemes get fontSize => _fontSizeThemes;
  GeneralThemes get generalThemes => _generalThemes;
}
