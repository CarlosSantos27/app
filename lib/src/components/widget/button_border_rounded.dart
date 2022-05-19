import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  final Widget label;
  final Function onPressed;
  final double borderRadius;

  const ButtonRounded({
    @required this.label,
    @required this.onPressed,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.borderRadius),
        border: Border.all(
          color: Color.fromRGBO(7, 76, 127, 1),
          width: 2,
        ),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: this.onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
              child: this.label,
            ),
          ),
        ),
      ),
    );
  }
}
