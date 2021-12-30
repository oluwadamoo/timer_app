import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import './timermodel.dart';

class CountDownTimer {
  int? work = 30;
  double? _radius = 1;
  bool _isActive = true;
  Timer? timer = Timer(Duration(minutes: 0), () => true);
  Duration? _time = Duration(minutes: 0);
  Duration? _fullTime = Duration(minutes: 0);
  int? shortBreak = 5;
  int? longBreak = 20;

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    shortBreak =
        prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak');
    longBreak =
        prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak');
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: work!, seconds: 0);
    _fullTime = _time;
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (_time!.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: isShort ? shortBreak! : longBreak!, seconds: 0);
    _fullTime = _time;
  }

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  double get percent => TimerModel(_time.toString(), _radius!).percent;
  String get time => TimerModel(_time.toString(), _radius!).time;

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (this._isActive) {
        _time = _time! - Duration(seconds: 1);
        _radius = _time!.inSeconds / _fullTime!.inSeconds;

        if (_time!.inSeconds <= 0) {
          _isActive = false;
        }
      }
      time = returnTime(_time!);
      return TimerModel(time, _radius!);
    });
  }
}
