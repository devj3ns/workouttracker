import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/screens/workoutDetails/workoutDetails.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/routes.dart';
import 'package:workouttracker/shared/extensions/dateExtensions.dart';
import 'package:workouttracker/shared/widgets/frostedBox.dart';
import 'package:workouttracker/shared/widgets/loading.dart';
import 'package:workouttracker/shared/widgets/roundIconButton.dart';

import 'workoutListItem.dart';

class DayWorkoutList extends StatelessWidget {
  final DateTime date;

  DayWorkoutList({@required this.date});

  void openWorkoutDetailsScreen(
      BuildContext context, DatabaseService database) {
    Navigator.of(context).push(
      SlideUpRoute(
        page: WorkoutDetails(
          dateTime: date,
          database: database,
        ),
      ),
    );
  }

  String get weekdayStr => DateFormat('EEEE').format(date);
  String get placeholderText => date.isFutureDay()
      ? "If you had a time machine you could probably see a workout her ;)"
      : date.isToday()
          ? "You didn't work out today."
          : date.isYesterday()
              ? "You didn't work out yesterday."
              : date.isThisWeek()
                  ? "You didn't work out on " + weekdayStr + "."
                  : "You didn't work out this day.";
  String get title => date.isToday() ? "Today" : weekdayStr;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;
    DatabaseService _database = DatabaseService(uid: user.uid);

    return FrostedBox(
      colorHighlight: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: StreamBuilder<List<Workout>>(
                stream: _database.workoutsAtDate(this.date),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Loading(),
                    );
                  } else {
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Text(placeholderText,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                      );
                    }
                    List<Workout> workouts = snapshot.data;

                    return ListView(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      children: workouts.map(
                        (workout) {
                          return WorkoutListItem(
                            workout: workout,
                            database: _database,
                          );
                        },
                      ).toList(),
                    );
                  }
                },
              ),
            ),
            date.isFutureDay()
                ? SizedBox(
                    height: 60,
                  )
                : Center(
                    child: RoundIconButton(
                      heroTag: "TransitionWithWorkoutDetailScreen",
                      icon: Icons.add,
                      onTap: () => openWorkoutDetailsScreen(context, _database),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
