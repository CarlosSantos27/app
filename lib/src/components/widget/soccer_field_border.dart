import 'dart:math';
import 'package:flutter/material.dart';

import 'package:futgolazo/src/utils/responsive.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class SoccerFieldBorder extends StateLessCustom {
  final Widget child;
  final Widget title;

  SoccerFieldBorder({this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        title == null
            ? Container()
            : Container(
                height: responsive.hp(5.3),
                child: Center(child: title),
                padding: EdgeInsets.only(left: responsive.hp(7)),
                color: colorsTheme.getColorBackground.withOpacity(.6),
              ),
        Container(
          child: CustomPaint(
            painter: CornerPainter(responsive),
            child: Container(
                padding: EdgeInsets.only(
                  top: title == null ? 0.0 : responsive.hp(4),
                ),
                child: child),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorsTheme.getColorSurface,
              width: responsive.ip(.3),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              height: responsive.hp(10),
              width: 0,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Column(
            children: <Widget>[
              Container(
                height: responsive.hp(10),
                width: 0,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CornerPainter extends CustomPainter {
  final Responsive responsive;

  CornerPainter(this.responsive);

  @override
  void paint(Canvas canvas, Size size) {
    Paint arcPaint = Paint();
    arcPaint.color = Colors.white;
    arcPaint.strokeWidth = responsive.ip(.3);
    arcPaint.style = PaintingStyle.stroke;

    double radius = (min(size.width / 2, size.height / 2)) * .15;
    // TOP LEFT CORNER
    canvas.drawArc(
      Rect.fromCircle(center: Offset(-1, -1), radius: radius),
      0,
      pi / 2,
      true,
      arcPaint,
    );

    // BOTTOM LEFT CORNER
    canvas.drawArc(
      Rect.fromCircle(center: Offset(-1, size.height + 1), radius: radius),
      pi * -.5,
      ((2 * pi) / 3) - .5,
      true,
      arcPaint,
    );

    // TOP RIGHT CORNER
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width + 1, -1), radius: radius),
      pi / 2,
      pi / 2,
      true,
      arcPaint,
    );

    // BOTTOM RIGHT CORNER
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width + 1, size.height + 1), radius: radius),
        pi,
        pi / 2,
        true,
        arcPaint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) => false;
}
