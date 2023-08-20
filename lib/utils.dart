
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

String numbers2Hour(int hour, int minutes) {
  final String m = (minutes < 10) ? "0$minutes" : minutes.toString();
  return "$hour:$m";
}

String number2Month(int month) {
  Map<int, String> months = {
    DateTime.january: "January",
    DateTime.february: "February",
    DateTime.march: "March",
    DateTime.april: "April",
    DateTime.may: "May",
    DateTime.june: "June",
    DateTime.july: "July",
    DateTime.august: "August",
    DateTime.september: "September",
    DateTime.october: "October",
    DateTime.november: "November",
    DateTime.december: "December",
  };

  return months[month] ?? '';
}

String number2Day(int day) {
  Map<int, String> days = {
    DateTime.sunday: "Sunday",
    DateTime.monday: "Monday",
    DateTime.tuesday: "Tuesday",
    DateTime.wednesday: "Wednesday",
    DateTime.thursday: "Thursday",
    DateTime.friday: "Friday",
    DateTime.saturday: "Saturday",
  };

  return days[day] ?? '';
}