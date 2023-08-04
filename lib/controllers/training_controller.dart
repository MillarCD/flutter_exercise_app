import 'package:flutter/foundation.dart';

import 'package:eapp/models/exercise.dart';
import 'package:eapp/models/series.dart';
import 'package:eapp/models/training.dart';
import 'package:eapp/persistence/db.dart';

class TrainingController extends ChangeNotifier{

  final List<Series> _series = [];
  Exercise? currentExercise;
  bool _isStarted = false;
  DateTime? _start;
  DateTime? _end;

  void startTraining() {
    _start = DateTime.now();
    _isStarted = true;
  } 

  bool get isStarted => _isStarted;

  List<Series> get series => _series;

  bool addSeries(double weight, int repetitions) {
    if (currentExercise == null) return false;
    _series.add(
      Series(idExercise: currentExercise!.id, weight: weight, repetitions: repetitions)
    );
    notifyListeners();
    return true;
  }

  void updateSeries(Series s, double weight, int reps) {
    s.weight = weight;
    s.repetitions = reps;
    notifyListeners();
  }

  void deleteSeriesByHashcode(int hc) {
    _series.removeWhere((s) => s.hashCode == hc);
    notifyListeners();
  }

  Future<Training?> endTraining() async {
    if (_start == null || _series.isEmpty) return null;
    _end = DateTime.now();
    final int id = await DB().createTraining(_series, _start!, _end!);
    final Training newTraining = Training(id: id, start: _start!, end: _end!);
    _series.clear();
    _start = null;
    _end = null;
    _isStarted = false;
    return newTraining;
  }

  void discartTraining() {
    if (_start == null && _series.isEmpty) return;

    _series.clear();
    _start = null;
    _end = null;
    _isStarted = false;
  }
  
}