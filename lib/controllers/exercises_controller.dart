import 'package:eapp/persistence/db.dart';
import 'package:flutter/material.dart';

import 'package:eapp/models/exercise.dart';

class ExercisesController extends ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  ExercisesController() {
    DB().getExercises().then(
      (value) {
        _exercises.addAll(value);
        _isLoading = false;
      } 
    );
  }

  List<Exercise> get exercises {
    if (_exercises.isNotEmpty) return _exercises;
    _isLoading = true;
    DB().getExercises().then(
      (value)  => _exercises.addAll(value)
    );

    _isLoading = false;
    notifyListeners();
    return _exercises;
  }

  Future<bool> createExercise(String name) async {
    final isUsed = await DB().checkExerciseByName(name);
    if (isUsed) return false;

    final Exercise? newExercise = await DB().createExercise(name);
    if (newExercise == null) return false;
    _exercises.add(newExercise);
    notifyListeners();
    return true;
  }

  Future<bool> updateExercise(Exercise exercise) async {
    final isUsed = await DB().checkExerciseByName(exercise.name);
    if (isUsed) return false;

    final int id = await DB().updateExercise(exercise);
    if (id<1) return false;

    _exercises = [..._exercises.where((e) => e.id != exercise.id), exercise];

    notifyListeners();
    return true;
  }

}