import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';
import '../../themes/color_themes.dart';
import '../../themes/general_themes.dart';
import '../../services/pool_services.dart';
import '../../themes/font_size_themes.dart';
export '../futgolazo_scaffold/futgolazo_scaffold.dart';

abstract class StateLessCustom extends StatelessWidget {
  final Key key;

  final TextTheme _textTheme;
  final Responsive _responsive;
  final ColorsThemes _colorsThemes;
  final GeneralThemes _generalThemes;
  final FontSizeThemes _fontSizeThemes;

  StateLessCustom({
    this.key,
  })  : _textTheme = GetIt.I<PoolServices>().futgolazoMainTheme.getTextTheme,
        _responsive = GetIt.I<PoolServices>().futgolazoMainTheme.getResponsive,
        _fontSizeThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.getFontSize,
        _generalThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.generalThemes,
        _colorsThemes =
            GetIt.I<PoolServices>().futgolazoMainTheme.getColorsTheme,
        super(
          key: key,
        );

  TextTheme get textTheme => _textTheme;
  Responsive get responsive => _responsive;
  ColorsThemes get colorsTheme => _colorsThemes;
  FontSizeThemes get fontSize => _fontSizeThemes;
  GeneralThemes get generalThemes => _generalThemes;
}
