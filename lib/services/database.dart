import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:workouttracker/models/userData.dart';
import 'package:workouttracker/models/workout.dart';

class DatabaseService {
  final uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');

  Future updateUserData(String username) async {
    return await userDataCollection.doc(uid).set({
      'username': username,
    });
  }

  Stream<UserData> get userData {
    return userDataCollection.doc(uid).snapshots().map((doc) {
      return UserData.fromDocument(doc);
    });
  }

  //add workout to db
  Future addWorkout(Workout workout) async {
    return await userDataCollection
        .doc(uid)
        .collection("workouts")
        .add(workout.toDocument());
  }

  //updates workout in db
  Future updateWorkout(Workout workout) async {
    if (workout.uid == null) {
      throw ("Cannot update workout in database because no uid is provided (workout.uid == null)!");
    } else {
      return await userDataCollection
          .doc(uid)
          .collection("workouts")
          .doc(workout.uid)
          .update(workout.toDocument());
    }
  }

  //delete workout from db
  Future deleteWorkout(Workout workout) async {
    return userDataCollection
        .doc(uid)
        .collection("workouts")
        .doc(workout.uid)
        .delete();
  }

  //workout list from snapshot
  List<Workout> _workoutsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Workout.fromDocument(doc);
    }).toList();
  }

  //get all workouts as stream
  Stream<List<Workout>> get workouts {
    return userDataCollection
        .doc(uid)
        .collection("workouts")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_workoutsFromSnapshot);
  }

  //get workouts made on a specific date as stream
  Stream<List<Workout>> workoutsAtDate(DateTime dateTime) {
    DateTime startOfDay =
        new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    DateTime endOfDay =
        new DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);

    return userDataCollection
        .doc(uid)
        .collection("workouts")
        .where("timestamp", isGreaterThan: startOfDay)
        .where("timestamp", isLessThanOrEqualTo: endOfDay)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_workoutsFromSnapshot);
  }

  //returns true if their is a workout tracked on that day
  Future<int> workoutsOnThatDay(DateTime dateTime) async {
    DateTime startOfDay =
        new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    DateTime endOfDay =
        new DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);

    return await userDataCollection
        .doc(uid)
        .collection("workouts")
        .where("timestamp", isGreaterThan: startOfDay)
        .where("timestamp", isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .length;
  }
}
