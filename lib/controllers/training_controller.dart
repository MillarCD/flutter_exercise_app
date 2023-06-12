
import 'package:eapp/models/series.dart';

class TrainingController {

  List<Series> series = [];
  DateTime? start;
  DateTime? end;

  static final TrainingController _instance = TrainingController._();
  TrainingController._();

  factory TrainingController() => _instance;

  void startTraining() {
    // TODO: setea la hora de inicio
  }

  void addSeries() {
    // TODO: agrega una serie a la lista
  }

  bool endTraining() {
    // TODO: guarda en la base de datos el entrenamiento

    // TODO: borra todas las varibles
    return false;
  }
}