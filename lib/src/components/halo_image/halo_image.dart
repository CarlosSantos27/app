import 'dart:math' as math;

import 'package:flutter/material.dart';

class HaloImage extends StatefulWidget {
  const HaloImage({Key key}) : super(key: key);

  @override
  _HaloImageState createState() => _HaloImageState();
}

class _HaloImageState extends State<HaloImage> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Image.asset(
        'assets/backgrounds/destello.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
