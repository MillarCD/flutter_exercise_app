
import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchController extends ChangeNotifier{
  Timer? timer;
  bool _started = false;
  int _seconds = 0;
  String _stopwatch = '00:00';

  String get stopwatch => _stopwatch;
  bool get started => _started;
  
  void start() {
    _started = true;
    int m = 0;
    int s = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      m = _seconds~/60;
      s = _seconds%60;
      _stopwatch = "${(m<10) ? '0$m' : m}:${(s<10) ? '0$s' : s}";
      notifyListeners();
    });
  }

  void stop() {
    if (timer == null) return;
    timer!.cancel();

    _started = false;
  }

  void reset() {
    if (timer == null) return;
    timer!.cancel();
    _seconds = 0;
    _started = false;
    _stopwatch = '00:00';
    notifyListeners();
  }
}