import 'dart:math' as math;
import 'dart:ui';

class Responsive {
  double _width, _height, _inch;

  Responsive() {
    _width = window.physicalSize.width / window.devicePixelRatio;
    _height = window.physicalSize.height / window.devicePixelRatio;

    _inch = _calculeInc();
  }

  double _calculeInc() => math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));

  double ip(double percent) => this._inch * percent / 100;

  double wp(double percent) => this._width * percent / 100;

  double hp(double percent) => this._height * percent / 100;

  double get aspectRatio => this._width / this._height;

  double get currentWidth => this._width;
  double get currentHeight => this._height;
}
