import 'package:flutter/material.dart';

import 'package:workouttracker/shared/dateExtensions.dart';
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
  static int selectedWeek = DateTime.now().getWeekNumber();
  static List<DateTime> datesInWeek = getDatesInWeekByWeekNumber(selectedWeek);

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
      datesInWeek = getDatesInWeekByWeekNumber(selectedWeek);
    });
  }

  void changeTab(DateTime date) {
    pageController.animateToPage(date.weekday - 1,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 275));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 596,
      child: Column(
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
              children: getDatesInWeekByWeekNumber(selectedWeek)
                  .map((DateTime dateTime) => DayWorkoutList(date: dateTime))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
