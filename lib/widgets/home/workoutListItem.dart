import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/screens/workoutDetails.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/routes.dart';
import 'package:workouttracker/widgets/frostedBox.dart';

class WorkoutListItem extends StatelessWidget {
  WorkoutListItem({
    this.workout,
    this.database,
  });

  final Workout workout;
  final DatabaseService database;

  void openWorkoutDetailsScreen(BuildContext context) {
    Navigator.of(context).push(
      SlideUpRoute(
        page: WorkoutDetails(
          database: database,
          dateTime: workout.timestamp,
          initialWorkoutData: workout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.Hm().format(workout.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: FrostedBox(
        customColor: Colors.blueGrey.shade100.withOpacity(0.8),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.dumbbell,
                size: 20,
              ),
            ],
          ),
          title: Text(workout.duration.toString() + "min " + workout.category),
          subtitle: Text(date),
        ),
        onTap: () => openWorkoutDetailsScreen(context),
      ),
    );
  }
}
