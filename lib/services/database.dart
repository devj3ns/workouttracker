import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workouttracker/models/userData.dart';
import 'package:workouttracker/models/workout.dart';

class DatabaseService {
  final uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      Firestore.instance.collection('userData');

  Future updateUserData(String username) async {
    return await userDataCollection.document(uid).setData({
      'username': username,
    });
  }

  Stream<UserData> get userData {
    return userDataCollection.document(uid).snapshots().map((doc) {
      return UserData.fromDocument(doc);
    });
  }

  //add workout to db
  Future addWorkout(Workout workout) async {
    return await userDataCollection
        .document(uid)
        .collection("workouts")
        .add(workout.toDocument());
  }

  //delete workout from db
  Future deleteWorkout(Workout workout) async {
    return userDataCollection
        .document(uid)
        .collection("workouts")
        .document(workout.uid).delete();
  }

  //workout list from snapshot
  List<Workout> _workoutsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Workout.fromDocument(doc);
    }).toList();
  }

  //get workouts stream
  Stream<List<Workout>> get workouts {
    return userDataCollection
        .document(uid)
        .collection("workouts")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_workoutsFromSnapshot);
  }
}
