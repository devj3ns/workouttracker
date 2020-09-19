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

  bool isFutureDay() {
    DateTime now = DateTime.now();
    return DateTime(this.year, this.month, this.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays >
        0;
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
