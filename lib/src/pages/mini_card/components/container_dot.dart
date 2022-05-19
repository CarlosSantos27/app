import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class ContainerDot extends StateLessCustom {
  final double height;
  final int currentIndex;
  final int itemCount;

  ContainerDot({
    Key key,
    @required this.height,
    @required this.itemCount,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorsTheme.getColorPrimary,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount,
          (index) => _buildDot(index),
        ),
      ),
    );
  }

  _buildDot(int index) {
    return Container(
      margin: EdgeInsets.only(
        right: index >= (itemCount - 1) ? 0.0 : responsive.wp(6),
      ),
      width: responsive.wp(3.5),
      height: responsive.wp(3.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index <= currentIndex
            ? colorsTheme.getColorButtonVariant
            : colorsTheme.getColorOnSurface,
      ),
    );
  }
}
