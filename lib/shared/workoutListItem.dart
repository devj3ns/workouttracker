import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/database.dart';

class WorkoutListItem extends StatelessWidget {
  WorkoutListItem({
    this.workout,
    this.database,
  });

  final Workout workout;
  final DatabaseService database;

  @override
  Widget build(BuildContext context) {
    print(workout.uid);
    String date = DateFormat.yMMMMd().format(workout.timestamp);
    return Card(
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.dumbbell),
        title: Text(workout.name),
        subtitle: Text(workout.description + "\n\n" + date),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => database.deleteWorkout(workout),
        ),
      ),
    );
  }
}
