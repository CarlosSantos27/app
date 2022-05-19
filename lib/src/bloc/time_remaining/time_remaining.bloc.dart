import 'dart:async';

import 'package:futgolazo/src/bloc/base/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TimeRemaining extends BaseBloc {
  static TimeRemaining _instance = TimeRemaining._internal();

  static Timer _timer;
  static DateTime _currentDate;

  static BehaviorSubject<DateTime> _currentDate$ = BehaviorSubject<DateTime>();

  factory TimeRemaining() {
    defineTimer();
    return _instance;
  }

  TimeRemaining._internal();

  Stream<DateTime> get currentDateStream => _currentDate$.stream;

  static defineTimer() {
    if (_timer != null) {
      return;
    }
    _currentDate$ = BehaviorSubject<DateTime>();
    _currentDate = DateTime.now();

    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        _currentDate = _currentDate.add(
          Duration(
            seconds: 1,
          ),
        );
        _currentDate$.add(_currentDate);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentDate$.close();
    _currentDate$ = null;
    _timer = null;
  }
}
