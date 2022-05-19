import 'dart:async';

import 'package:flutter/material.dart';

class JumpAnimation extends StatefulWidget {
  final Widget child;
  final bool animateWidget;

  JumpAnimation({
    Key key,
    @required this.child,
    this.animateWidget = true,
  }) : super(key: key);

  @override
  _JumpAnimationState createState() => _JumpAnimationState();
}

class _JumpAnimationState extends State<JumpAnimation>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  double iconSize = 1.0;
  double maxIconSize = .2;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    if (widget.animateWidget) {
      _timer = Timer.periodic(Duration(seconds: 4), (timer) {
        if (widget.animateWidget) {
          _startAnimation();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: iconSize,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  _startAnimation() {
    final Animation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(curve)
      ..addStatusListener(
        (state) {
          if (state == AnimationStatus.completed) {
            _controller.reverse();
          }
        },
      )
      ..addListener(
        () {
          setState(() {
            iconSize = 1 + maxIconSize * _animation.value;
          });
        },
      );
    _controller.forward();
  }
}
