class Exercise {
  final int id;
  final String name;

  Exercise({
    required this.id,
    required this.name
  });

  factory Exercise.fromMap(Map<String, dynamic> exercise) {
    return Exercise(id: exercise['id'], name: exercise['name']);
  }
}