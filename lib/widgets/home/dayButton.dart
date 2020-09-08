import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/widgets/frostedBox.dart';
import 'package:workouttracker/shared/dateExtensions.dart';

class DayButton extends StatelessWidget {
  final DateTime date;
  final Function changeDate;
  final bool currentlySelected;

  DayButton({
    @required this.date,
    @required this.changeDate,
    @required this.currentlySelected,
  });

  @override
  Widget build(BuildContext context) {
    final String weekdayAbbr = DateFormat('EEEE').format(date).substring(0, 1);
    final String day = date.day.toString().padLeft(2, "0");

    final user = Provider.of<AuthService>(context).user;
    DatabaseService _database = DatabaseService(uid: user.uid);

    return FrostedBox(
      colorHighlight: currentlySelected,
      borderHighlight: date.isToday(),
      child: InkWell(
        onTap: () => changeDate(date),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                weekdayAbbr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                day + ".",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              StreamBuilder<List<Workout>>(
                stream: _database.workoutsAtDate(this.date),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          color: Colors.redAccent.withOpacity(0.8),
                          child: SizedBox(
                            width: 5,
                            height: 5,
                          ),
                        ),
                      );
                    }
                  }
                  return SizedBox(
                    width: 5,
                    height: 5,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
