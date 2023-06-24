
class Training {
  final int id;
  final DateTime start;
  final DateTime end;

  Training({
    required this.id,
    required this.start,
    required this.end
  });

  factory Training.fromMap(Map<String, dynamic> json) {
    // TODO: cambiar en la base de datos
    return Training(
      id: json['id'],
      start: DateTime.parse(json['start_datetime']),
      end: DateTime.parse(json['end_datetime'])
    );
  }
}