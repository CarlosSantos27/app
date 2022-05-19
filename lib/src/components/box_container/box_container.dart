import 'package:flutter/material.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';
import 'package:futgolazo/src/utils/responsive.dart';
import 'package:get_it/get_it.dart';

class BoxContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color backgroundColor;

  BoxContainer({@required this.child, this.radius, this.backgroundColor});
  FutgolazoMainTheme get _theme => GetIt.I<PoolServices>().futgolazoMainTheme;
  Responsive get _responsive => _theme.getResponsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _responsive.wp(3),
        vertical: _responsive.hp(.8),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? _theme.getColorsTheme.getColorBackground,
        border: Border.all(
            color: _theme.getColorsTheme.getColorSurface, width: _responsive.ip(.35)),
        borderRadius:
            BorderRadius.circular(radius == null ? _responsive.ip(2) : radius),
      ),
      child: child,
    );
  }
}
