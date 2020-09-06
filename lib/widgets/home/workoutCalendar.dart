import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/widgets/home/dayButton.dart';
import 'package:workouttracker/widgets/home/dayWorkoutList.dart';
import 'package:workouttracker/widgets/home/weekRow.dart';

class WorkoutCalendar extends StatefulWidget {
  @override
  _WorkoutCalendarState createState() => new _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  PageController pageController;
  int currentTabIndex = DateTime.now().weekday - 1;
  static int selectedWeek = getWeekNumber(DateTime.now());
  static List<DateTime> datesInWeek = getDatesInWeek();

  static int getWeekNumber(DateTime dateTime) {
    int dayOfYear = int.parse(DateFormat("D").format(dateTime));
    return ((dayOfYear - DateTime.now().weekday + 10) / 7).floor();
  }

  static List<DateTime> getDatesInWeek() {
    final DateTime today = DateTime.now();
    final int currentWeek = getWeekNumber(today);
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

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: currentTabIndex, keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changeWeek(int difference) {
    setState(() {
      selectedWeek += difference;
      datesInWeek = getDatesInWeek();
    });
  }

  void changeTab(DateTime date) {
    pageController.animateToPage(date.weekday - 1,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 275));
  }

  bool sameDay(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.day == dateTime2.day &&
        dateTime1.month == dateTime2.month &&
        dateTime1.year == dateTime2.year) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 596,
      child: ListView(
        children: <Widget>[
          WeekRow(
            changeWeek: changeWeek,
            selectedWeek: selectedWeek,
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: datesInWeek.map(
              (DateTime date) {
                return DayButton(
                  date: date,
                  changeDate: changeTab,
                  currentlySelected:
                      currentTabIndex == (datesInWeek.indexOf(date)),
                );
              },
            ).toList(),
          ),
          Container(
            height: 481,
            width: 500,
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentTabIndex = index;
                });
              },
              children: getDatesInWeek()
                  .map((DateTime dateTime) => DayWorkoutList(date: dateTime))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
