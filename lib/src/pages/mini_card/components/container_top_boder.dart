import 'package:flutter/material.dart';

import '../../../components/custom_scafold/stateless_custom.dart';

class ContainerTopBorder extends StateLessCustom {
  final Widget child;

  ContainerTopBorder({
    @required this.child,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: responsive.hp(3),
        ),
        // height: responsive.hp(6),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorsTheme.getColorOnSurface,
              width: 2.0,
            ),
          ),
        ),
        child: child);
  }
}
