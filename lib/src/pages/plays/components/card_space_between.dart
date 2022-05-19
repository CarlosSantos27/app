import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

class CardSpaceBetween extends StateLessCustom {
  final Color background;
  final Widget leftChild;
  final int leftFlex;
  final Widget rightChild;
  final int rightFlex;
  final double width;
  final double verticalPadding;
  final double horizontalPadding;
  final CrossAxisAlignment crossAxisAlignment;
  final Function onTap;

  CardSpaceBetween({
    Key key,
    @required this.leftChild,
    @required this.rightChild,
    this.background = Colors.white,
    this.verticalPadding,
    this.horizontalPadding,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.width,
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double defaultPadding = responsive.ip(1.0);
    final double defaultVerticalPadding = verticalPadding ?? defaultPadding;
    final double defaultHorizontalPadding = horizontalPadding ?? defaultPadding;
    EdgeInsets newLeftPadding = EdgeInsets.fromLTRB(
        defaultHorizontalPadding,
        defaultVerticalPadding,
        defaultHorizontalPadding / 2,
        defaultVerticalPadding);
    EdgeInsets newRightPadding = EdgeInsets.fromLTRB(
        defaultHorizontalPadding / 2,
        defaultVerticalPadding,
        defaultHorizontalPadding,
        defaultVerticalPadding);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(
            responsive.ip(1.5),
          ),
        ),
        width: width ?? double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(
                flex: leftFlex,
                child: Padding(padding: newLeftPadding, child: leftChild)),
            Expanded(
                flex: rightFlex,
                child: Padding(padding: newRightPadding, child: rightChild)),
          ],
        ),
      ),
    );
  }
}
