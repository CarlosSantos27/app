import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class IrregularRoundedContainer extends StateLessCustom {
  final Widget child;
  final Color backgroundColor;

  IrregularRoundedContainer({
    Key key,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: Container(
          color: backgroundColor ?? colorsTheme.getColorPrimary,
          child: child,
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = size.width * .168;

    Path path = Path()
      ..moveTo(radius, radius * .08)
      ..lineTo(
        size.width - radius,
        size.height * .022,
      )
      ..arcToPoint(
        Offset(size.width, radius),
        radius: Radius.circular(
          radius,
        ),
      )
      ..lineTo(
        size.width - size.width * .016,
        size.height - radius,
      )
      ..arcToPoint(
        Offset(size.width - radius * .7, size.height - radius * .44),
        radius: Radius.circular(
          radius * .6,
        ),
      )
      ..lineTo(size.width * .168, size.height - radius * .25)
      ..arcToPoint(
        Offset(radius * .2, size.height - radius),
        radius: Radius.circular(
          radius * .7,
        ),
      )
      ..lineTo(
        0,
        radius * .7,
      )
      ..arcToPoint(
        Offset(radius * .48, radius * .07),
        radius: Radius.circular(
          radius * .6,
        ),
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
