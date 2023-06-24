
import 'package:eapp/models/exercise.dart';
import 'package:eapp/models/series.dart';
import 'package:eapp/persistence/db.dart';

class TrainingController {

  List<Series> _series = [];
  Exercise? currentExercise;
  DateTime? _start;
  DateTime? _end;

  static final TrainingController _instance = TrainingController._();
  TrainingController._();

  factory TrainingController() => _instance;

  void startTraining() => _start = DateTime.now();

  bool addSeries(double weight, int repetitions) {
    if (currentExercise == null) return false;
    _series.add(
      Series(idExercise: currentExercise!.id, weight: weight, repetitions: repetitions)
    );
    return true;
  }

  Future<bool> endTraining() async {
    if (_start == null) return false;
    _end = DateTime.now();
    // TODO: guarda en la base de datos el entrenamiento
    await DB().createTraining(_series, _start!, _end!);
    _series.clear();
    _start = null;
    _end = null;
    return true;
  }
}