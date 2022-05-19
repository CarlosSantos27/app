class DateForHuman {
  DateTime _currentDate;
  final DateTime _date;
  Duration _timeDifference;
  List<String> _daysWeek;

  DateForHuman(this._date) {
    _currentDate = DateTime.now();
    this.calculateDate(_currentDate);
    _daysWeek = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado'
    ];
  }

  void calculateDate(DateTime dateTime) {
    _timeDifference = _date.difference(dateTime);
  }

  String get remaining => _remaining();

  String get day => _remaining();
  String get time => _time();

  String get dayWeek => _daysWeek[_date.weekday];

  String _remaining() {
    return _timeDifference.inDays > 0
        ? '${_timeDifference.inDays}d ${_calculateHours()}h ${_calculateMinutes()}m'
        : '${_timeDifference.inHours}h ${_calculateMinutes()}m ${_calculateSecond()}s';
  }

  String _time() {
    String hour =
        '00'.substring(_date.hour.toString().length) + _date.hour.toString();
    String minute = '00'.substring(_date.minute.toString().length) +
        _date.minute.toString();
    return '$hour:$minute';
  }

  String dateFormatString([String format]) {
    if (format == null) return '${_date.day}-${_date.month}-${_date.year}';

    String day =
        '00'.substring(_date.day.toString().length) + _date.day.toString();
    String month = (format.contains('mm')
            ? '00'.substring(_date.month.toString().length)
            : '') +
        _date.month.toString();
    return format
        .replaceAll('dd', day)
        .replaceAll('mm', month)
        .replaceAll('m', month);
  }

  int _calculateHours() {
    return _timeDifference.inHours - (_timeDifference.inDays * 24);
  }

  int _calculateMinutes() {
    return _timeDifference.inMinutes - (_timeDifference.inHours * 60);
  }

  int _calculateSecond() {
    return _timeDifference.inSeconds - (_timeDifference.inMinutes * 60);
  }
}
