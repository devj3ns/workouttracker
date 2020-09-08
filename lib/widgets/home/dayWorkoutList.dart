import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/screens/workoutDetails.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/routes.dart';
import 'package:workouttracker/widgets/home/workoutListItem.dart';
import 'package:workouttracker/widgets/loading.dart';
import 'package:workouttracker/shared/dateExtensions.dart';
import '../roundIconButton.dart';
import '../frostedBox.dart';

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

  bool get isInFuture => date.isAfter(DateTime.now());
  String get weekdayStr => DateFormat('EEEE').format(date);
  String get placeholderText => isInFuture
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

    return Padding(
      padding: const EdgeInsets.all(4.5),
      child: FrostedBox(
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
              Container(
                height: 350,
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
              isInFuture
                  ? SizedBox(
                      height: 60,
                    )
                  : Center(
                      child: RoundIconButton(
                        heroTag: "TransitionWithWorkoutDetailScreen",
                        icon: Icons.add,
                        onTap: () =>
                            openWorkoutDetailsScreen(context, _database),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
