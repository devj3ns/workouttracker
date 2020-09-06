import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isToday() {
    DateTime other = DateTime.now();

    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getWeekNumber() {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    return ((dayOfYear - DateTime.now().weekday + 10) / 7).floor();
  }
}

List<DateTime> getDatesInWeekByWeekNumber(int selectedWeek) {
  final DateTime today = DateTime.now();
  final int currentWeek = today.getWeekNumber();
  final weekDifferences = currentWeek - selectedWeek;

  final DateTime dayInSelectedWeek =
  today.subtract(Duration(days: weekDifferences * 7));

  final DateTime firstDayOfTheWeek = dayInSelectedWeek
      .subtract(Duration(days: dayInSelectedWeek.weekday - 1));

  List<DateTime> datesInWeek = [];

  for (var i = 0; i < 7; i++) {
    datesInWeek.add(firstDayOfTheWeek.add(Duration(days: i)));
  }

  return datesInWeek;
}

bool nextWeekInFutureByWeekNumber(int selectedWeek){
  //get first day of next week (week after currently selected week)
  final DateTime today = DateTime.now();
  final int currentWeek = today.subtract(Duration(days: 7)).getWeekNumber();
  final weekDifferences = currentWeek - selectedWeek;

  final DateTime dayInSelectedWeek =
  today.subtract(Duration(days: weekDifferences * 7));

  final DateTime firstDayOfTheWeek = dayInSelectedWeek
      .subtract(Duration(days: dayInSelectedWeek.weekday - 1));

  //check if in future
  return firstDayOfTheWeek.isAfter(DateTime.now());
}