import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/widgets/frostedBox.dart';

class WeekRow extends StatelessWidget {
  final Function changeWeek;
  final int selectedWeek;

  WeekRow({
    @required this.changeWeek,
    @required this.selectedWeek,
  });

  bool nextWeekInFuture() {
    //get first day of next week (week after currently selected week)
    final DateTime today = DateTime.now();
    final int currentWeek = getWeekNumber(today.subtract(Duration(days: 7)));
    final weekDifferences = currentWeek - selectedWeek;

    final DateTime dayInSelectedWeek =
    today.subtract(Duration(days: weekDifferences * 7));

    final DateTime firstDayOfTheWeek = dayInSelectedWeek
        .subtract(Duration(days: dayInSelectedWeek.weekday - 1));

    //check if in future
    return !firstDayOfTheWeek.difference(DateTime.now()).isNegative;
  }

  int getWeekNumber(DateTime dateTime) {
    int dayOfYear = int.parse(DateFormat("D").format(dateTime));
    return ((dayOfYear - DateTime.now().weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FrostedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(
                    Icons.arrow_back_ios,
                    // color: Colors.white,
                    size: 18,
                  ),
                ),
                onTap: () => changeWeek(-1) //subtracts one week,
                ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "Week No. " + selectedWeek.toString(),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(
                    Icons.arrow_forward_ios,
                    color: nextWeekInFuture() ? Colors.grey : Colors.black,
                    size: 18,
                  ),
                ),
                onTap: () => nextWeekInFuture() ? null : changeWeek(1) //adds one week,
                ),
          ],
        ),
      ),
    );
  }
}
