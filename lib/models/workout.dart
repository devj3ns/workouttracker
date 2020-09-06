import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String uid;
  final String name;
  final String description;
  final DateTime timestamp;

  Workout({
    this.uid,
    this.name,
    this.description,
    this.timestamp,
  });

  factory Workout.fromDocument(DocumentSnapshot doc) {
    return Workout(
      uid: doc.documentID,
      name: doc["name"],
      description: doc["description"],
      timestamp: doc["timestamp"].toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": this.name,
      "description": this.description,
      "timestamp": this.timestamp,
    };
  }
}
