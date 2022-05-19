import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function onPressed;

  const CircularIconButton({
    @required this.icon,
    @required this.color,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
    );
  }
}
