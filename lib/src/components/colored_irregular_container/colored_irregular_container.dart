import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../widget/irregular_rounded_container.dart';

class ColoredIrregularContianer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const ColoredIrregularContianer({
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IrregularRoundedContainer(
      backgroundColor: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/backgrounds/bgMascotasMultiply.svg',
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.multiply,
          ),
          child,
        ],
      ),
    );
  }
}
