
String getDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}";
}

String hoursBetweenDates(DateTime date1, DateTime date2) {
  int minutes = date2.difference(date1).inMinutes;
  int m = minutes%60;
  return "${minutes~/60} hrs ${(m<10) ? '0$m' : m} min";
}

double calcOneRM(double weight, int reps) {
  return weight / (1.0278 - (0.0278 * reps));
}