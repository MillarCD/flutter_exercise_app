import 'package:flutter/material.dart';

import 'package:eapp/models/training.dart';
import 'package:eapp/persistence/db.dart';


class TrainingHistoryController extends ChangeNotifier {
  List<Training> _trainings = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  TrainingHistoryController() {
    DB().getTrainings().then(
      (value) {
        _trainings.addAll(value);
        _isLoading = false;
        notifyListeners();
      }
    );
  }

  List<Training> get trainings => _trainings;

  Future<bool> deleteTrainingById(int idTraining) async {
    print('borrando desde el controlador...');
    final bool res = await DB().deleteTrainingById(idTraining);
    print('recivio la respuesta: $res');
    if (!res) return res;
    
    _trainings = [ ..._trainings.where((t) => t.id != idTraining) ];
    notifyListeners();
    return true;
  }

  void addTraining(Training newTraining) {
    _trainings.add(newTraining);
    notifyListeners();
  }
}