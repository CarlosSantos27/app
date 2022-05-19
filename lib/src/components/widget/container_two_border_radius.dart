import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class ContainerTwoBorderRadius extends StateLessCustom {
  final Widget child;

  ContainerTwoBorderRadius({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
        vertical: responsive.hp(.5),
      ),
      decoration: BoxDecoration(
        color: colorsTheme.getColorOnButton,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            responsive.wp(3),
          ),
          topRight: Radius.circular(
            responsive.wp(3),
          ),
        ),
      ),
      child: child,
    );
  }
}