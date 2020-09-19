import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';

import 'package:workouttracker/shared/extensions/widgetExtensions.dart';

import 'dayButton.dart';
import 'dayWorkoutList.dart';
import 'weekRow.dart';

class WorkoutCalendar extends StatefulWidget {
  @override
  _WorkoutCalendarState createState() => new _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  PageController pageController;
  int currentTabIndex = DateTime.now().weekday - 1;
  static Week selectedWeek = Week.current();

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

  void nextWeek() {
    setState(() {
      selectedWeek = selectedWeek.next;
    });
  }

  void previousWeek() {
    setState(() {
      selectedWeek = selectedWeek.previous;
    });
  }

  void changeTab(DateTime date) {
    pageController.animateToPage(date.weekday - 1,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 275));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WeekRow(
          nextWeek: nextWeek,
          previousWeek: previousWeek,
          selectedWeek: selectedWeek,
        ).withPadding(bottom: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: selectedWeek.days.map(
            (DateTime date) {
              return DayButton(
                date: date,
                changeDate: changeTab,
                currentlySelected:
                    currentTabIndex == selectedWeek.days.indexOf(date),
              );
            },
          ).toList(),
        ).withPadding(bottom: 8),
        Expanded(
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            children: selectedWeek.days
                .map((DateTime dateTime) => DayWorkoutList(date: dateTime))
                .toList(),
          ),
        ),
      ],
    );
  }
}
