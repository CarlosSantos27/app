import 'package:flutter/material.dart';

import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class TextStroke extends StateLessCustom {
  final String text;
  final TextStyle style;
  final Color color;
  final double strokeWidth;
  final TextAlign textAlign;

  TextStroke(
    this.text, {
    this.style,
    this.color,
    this.strokeWidth,
    this.textAlign,

    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text.toString(),
      textAlign: this.textAlign,
      style: style ??
          fontSize.headline3().copyWith(
                fontFamily: 'TitanOne',
              ),
    );

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            textWidget.data,
            textAlign: this.textAlign,
            style: textWidget.style.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth ?? 6.0
                ..color = color ?? Colors.black,
            ),
          ),
          textWidget,
        ],
      ),
    );
  }
}
