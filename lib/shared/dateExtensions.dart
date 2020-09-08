extension DateExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isToday() {
    DateTime today = DateTime.now();

    return this.year == today.year &&
        this.month == today.month &&
        this.day == today.day;
  }

  bool isYesterday() {
    DateTime now = DateTime.now();
    return DateTime(this.year, this.month, this.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        -1;
  }

  int getWeekNumber() {
    //get Week Number according to ISO 8601
    int daysToAdd = DateTime.thursday - this.weekday;
    DateTime thursdayDate = daysToAdd > 0
        ? this.add(Duration(days: daysToAdd))
        : this.subtract(Duration(days: daysToAdd.abs()));
    int dayOfYearThursday =
        thursdayDate.difference(DateTime(thursdayDate.year, 1, 1)).inDays;
    return 1 + ((dayOfYearThursday - 1) / 7).floor();
  }

  bool isThisWeek() {
    return this.getWeekNumber() == DateTime.now().getWeekNumber();
  }
}

List<DateTime> getDatesInWeekByWeekNumber(int selectedWeek) {
  final DateTime today = DateTime.now();
  final int currentWeek = today.getWeekNumber();
  final weekDifferences = currentWeek - selectedWeek;

  final DateTime dayInSelectedWeek =
      today.subtract(Duration(days: weekDifferences * 7));

  final DateTime firstDayOfTheWeek =
      dayInSelectedWeek.subtract(Duration(days: dayInSelectedWeek.weekday - 1));

  List<DateTime> datesInWeek = [];

  for (var i = 0; i < 7; i++) {
    datesInWeek.add(firstDayOfTheWeek.add(Duration(days: i)));
  }

  return datesInWeek;
}

bool nextWeekInFutureByWeekNumber(int selectedWeek) {
  //get first day of next week (week after currently selected week)
  final DateTime today = DateTime.now();
  final int currentWeek = today.subtract(Duration(days: 7)).getWeekNumber();
  final weekDifferences = currentWeek - selectedWeek;

  final DateTime dayInSelectedWeek =
      today.subtract(Duration(days: weekDifferences * 7));

  final DateTime firstDayOfTheWeek =
      dayInSelectedWeek.subtract(Duration(days: dayInSelectedWeek.weekday - 1));

  //check if in future
  return firstDayOfTheWeek.isAfter(DateTime.now());
}
