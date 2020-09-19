import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isoweek/isoweek.dart';

import 'package:workouttracker/shared/widgets/frostedBox.dart';
import 'package:workouttracker/shared/extensions/dateExtensions.dart';



class WeekRow extends StatelessWidget {
  final Function nextWeek;
  final Function previousWeek;
  final Week selectedWeek;

  WeekRow({
    @required this.nextWeek,
    @required this.previousWeek,
    @required this.selectedWeek,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedBox(
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
              onTap: previousWeek //subtracts one week,
              ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              "Calendar week " + selectedWeek.weekNumber.toString(),
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
                  color: selectedWeek.next.day(0).isFutureDay()
                      ? Colors.grey
                      : Colors.black,
                  size: 18,
                ),
              ),
              onTap: selectedWeek.next.day(0).isFutureDay()
                  ? null
                  : nextWeek //adds one week,
              ),
        ],
      ),
    );
  }
}
