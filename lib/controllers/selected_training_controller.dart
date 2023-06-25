import 'package:flutter/foundation.dart';

import 'package:eapp/models/exercise.dart';
import 'package:eapp/models/series.dart';
import 'package:eapp/models/training.dart';
import 'package:eapp/persistence/db.dart';

class SelectedTrainingController extends ChangeNotifier {
  final List<List<Series>> _series = [];
  final Map<int, Exercise>  _exercises = {};
  Training? _training;

  bool _isLoading = false;

  List<List<Series>> get series => _series;
  Map<int, Exercise> get exercises => _exercises; 
  bool get isLoading => _isLoading;

  Training? get training => _training;
  set training(Training? t) {
    if (t == null) return;
    _isLoading = true;
    _training = t;
    _loadData();
  }

  Future<void> _loadData() async {
    _series.clear();
    _exercises.clear();
    final List<Series> s = await DB().getSeriesByIdTraining(_training!.id);
    int i = 0;
    _series.add([s[0]]);
    // Agrupa las series que tienen el mismo ejercicio
    for (int j=1; j<s.length; j++) { 
      if (s[j].idExercise == _series[i][0].idExercise) {
        _series[i].add(s[j]);
        continue;
      }
      _series.add([s[j]]);
      i++;
    }

    final List<Exercise> e = await DB().getExercises();
    for (var el in e) {
      _exercises[el.id] = el;
    }
    _isLoading = false;
    notifyListeners();
  }

}