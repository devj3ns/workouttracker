import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String uid;
  final String category; //Upper body, shoulders, chest....
  final int duration; //5-60min
  final int intensity; //0: easy, 5: medium, 10: hard)
  final int rating; //0: exhausted, 5: okay, 10: happy)
  final String note;
  final DateTime timestamp;

  Workout({
    this.uid,
    this.category,
    this.duration,
    this.intensity,
    this.rating,
    this.note,
    this.timestamp,
  });

  factory Workout.fromDocument(DocumentSnapshot doc) {
    return Workout(
      uid: doc.documentID,
      category: categories[doc["category"]], //translate id from db to string (see Map below)
      duration: doc["duration"],
      intensity: doc["intensity"],
      rating: doc["rating"],
      note: doc["note"],
      timestamp: doc["timestamp"].toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "category": categories.keys.firstWhere((key) =>
          categories[key] == this.category), //translate String to id for db (see Map below)
      "duration": this.duration,
      "intensity": this.intensity,
      "rating": this.rating,
      "note": this.note,
      "timestamp": this.timestamp,
    };
  }
}

Map<int, String> categories = {
  0: "Upper Body",
  1: "Shoulders",
  2: "Chest",
  3: "Abs",
  4: "Arms",
  5: "Back",
  6: "Legs",
  7: "Booty",
};
