class Series {
  double weight;
  int repetitions;
  final int idExercise;

  Series({
    required this.idExercise,
    required this.weight,
    required this.repetitions,
  });

  factory Series.fromMap(Map<String, dynamic> json) {
    return Series(
      weight: json['weight'],
      repetitions: json['repetitions'],
      idExercise: json['id_exercise'] 
    );
  }
}