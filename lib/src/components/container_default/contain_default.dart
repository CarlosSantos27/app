import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class ContainerDefault extends StateLessCustom {
  final Widget child;
  final EdgeInsets padding;
  final Color background;
  final List<BoxShadow> boxShadow;

  ContainerDefault({
    Key key,
    @required this.child,
    this.boxShadow,
    this.background,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EdgeInsets newPadding = padding ??
        EdgeInsets.all(
          responsive.ip(1.8),
        );
    return Container(
      decoration: BoxDecoration(
        color: background ?? colorsTheme.getColorPrimary,
        borderRadius: BorderRadius.circular(
          responsive.ip(2.2),
        ),
        boxShadow: boxShadow ?? [],
      ),
      width: double.infinity,
      padding: newPadding,
      child: child,
    );
  }
}
