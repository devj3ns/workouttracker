import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:workouttracker/shared/dateExtensions.dart';
import 'package:workouttracker/widgets/frostedBox.dart';

class WeekRow extends StatelessWidget {
  final Function changeWeek;
  final int selectedWeek;

  WeekRow({
    @required this.changeWeek,
    @required this.selectedWeek,
  });

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
                "Calendar week " + selectedWeek.toString(),
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
                    color: nextWeekInFutureByWeekNumber(selectedWeek)
                        ? Colors.grey
                        : Colors.black,
                    size: 18,
                  ),
                ),
                onTap: () => nextWeekInFutureByWeekNumber(selectedWeek)
                    ? null
                    : changeWeek(1) //adds one week,
                ),
          ],
        ),
      ),
    );
  }
}
