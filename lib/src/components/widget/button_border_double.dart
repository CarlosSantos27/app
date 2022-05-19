import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/themes/futgolazo_theme.dart';

class ButtonBorderDouble extends StatelessWidget {
  final Widget child;
  final double radius;
  final Gradient gradient;
  final double verticalPadding;
  final double horizontalPadding;
  final GestureTapCallback ontap;

  static FutgolazoMainTheme get _theme =>
      GetIt.I<PoolServices>().futgolazoMainTheme;

  ButtonBorderDouble.green({
    this.child,
    this.radius = 10.0,
    this.verticalPadding,
    this.horizontalPadding,
    @required this.ontap,
  }) : gradient = LinearGradient(
          colors: [
            _theme.getColorsTheme.getColorOnButton,
            _theme.getColorsTheme.getColorButton,
          ],
          stops: [.1, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(_theme.getResponsive.ip(.3)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _theme.getColorsTheme.getColorSurfaceVariant,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding != null
                      ? verticalPadding
                      : _theme.getResponsive.ip(1),
                  horizontal: horizontalPadding != null
                      ? horizontalPadding
                      : _theme.getResponsive.ip(3),
                ),
                child: child,
              ),
              decoration: BoxDecoration(
                gradient: _defineGradient(ontap != null),
                borderRadius: BorderRadius.circular(radius / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Gradient _defineGradient(bool disabled) {
    if (disabled) {
      return gradient;
    } else {
      return LinearGradient(
        colors: [
          Colors.grey,
          Colors.grey.shade200,
        ],
        stops: [.1, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
