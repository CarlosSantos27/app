import 'dart:async';
import 'package:async/async.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../../services/pool_services.dart';

class SponsorContainer extends StatefulWidget {
  SponsorContainer({Key key}) : super(key: key);

  @override
  _SponsorContainerState createState() => _SponsorContainerState();
}

class _SponsorContainerState extends State<SponsorContainer> {
  final _futgolazoMainTheme = GetIt.I<PoolServices>().futgolazoMainTheme;

  ScrollController _controller;
  double positionX = 0.0;
  Timer _timer;
  double _stepsPixels;
  CancelableOperation _delayFuture;

  @override
  void initState() {
    _stepsPixels = _futgolazoMainTheme.getResponsive.wp(7);
    _controller = new ScrollController();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _delayFuture = CancelableOperation.fromFuture(
          Future.delayed(
            Duration(seconds: 3),
            () {
              if (_controller != null && _controller?.position != null) {
                _timer = Timer.periodic(
                  Duration(seconds: 1),
                  (timer) {
                    double widthElement = _controller.position.maxScrollExtent;
                    if (positionX > widthElement || positionX < 0) {
                      _stepsPixels *= -1;
                    }
                    _controller.position.maxScrollExtent;
                    _controller.animateTo(
                      positionX += _stepsPixels,
                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _delayFuture?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _sponsorContainer(),
    );
  }

  Widget _sponsorContainer() {
    return Container(
      color: _futgolazoMainTheme.getColorsTheme.getColorBackground,
      height: _futgolazoMainTheme.getResponsive.hp(7),
      child: ListView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Image.asset(
            'assets/trivia/sponsors/economicas.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/mineggo.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/medicity.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/areadeportiva.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/jobra.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/economicas.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/mineggo.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/medicity.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/areadeportiva.jpg',
            fit: BoxFit.contain,
          ),
          Image.asset(
            'assets/trivia/sponsors/jobra.jpg',
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
