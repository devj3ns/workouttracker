import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/workoutListItem.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    DatabaseService _database = DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: AppBar(title: Text("Workout history")),
      body: StreamBuilder<List<Workout>>(
        stream: _database.workouts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Workout> workouts = snapshot.data;

            return ListView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: workouts.map((workout) {
                  return WorkoutListItem(
                    workout: workout,
                    database: _database,
                  );
                }).toList());
          } else {
            List<Workout> workouts = snapshot.data;
            //print(workouts);
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
