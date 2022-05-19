import 'package:flutter/material.dart';

class ButtonBorderSingleColor extends StatelessWidget {
  final Color color;
  final Widget child;
  final double height;
  final double width;
  final GestureTapCallback ontap;
  ButtonBorderSingleColor({
    this.color,
    this.child,
    this.height,
    this.width,
    @required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: width,
          height: height,
          child: Center(child: child),
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: color != null ? ontap == null ? Colors.grey : color : null,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
