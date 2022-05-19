import 'package:flutter/material.dart';

class RoundedContainerThreeLinear extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final List<Color> colors;

  RoundedContainerThreeLinear({
    Key key,
    this.child,
    this.colors,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(
          6,
        ),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
