
import 'package:eapp/models/exercise.dart';
import 'package:eapp/models/series.dart';
import 'package:eapp/persistence/db.dart';

class TrainingController {

  final List<Series> _series = [];
  Exercise? currentExercise;
  bool _isStarted = false;
  DateTime? _start;
  DateTime? _end;

  static final TrainingController _instance = TrainingController._();
  TrainingController._();

  factory TrainingController() => _instance;

  void startTraining() {
    _start = DateTime.now();
    _isStarted = true;
  } 

  bool get isStarted => _isStarted;

  bool addSeries(double weight, int repetitions) {
    if (currentExercise == null) return false;
    _series.add(
      Series(idExercise: currentExercise!.id, weight: weight, repetitions: repetitions)
    );
    return true;
  }

  Future<bool> endTraining() async {
    if (_start == null || _series.isEmpty) return false;
    _end = DateTime.now();
    await DB().createTraining(_series, _start!, _end!);
    _series.clear();
    _start = null;
    _end = null;
    _isStarted = false;
    return true;
  }
}