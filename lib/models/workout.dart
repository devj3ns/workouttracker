import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String uid;
  final String category; //Upper body, shoulders, chest....
  final int duration; //5-60min
  final int intensity; //1-3 (1: easy, 2: medium, 3: hard)
  final int rating; //1-3 (1: exhausted, 2: okay, 3: happy)
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
      category: categories[doc["category"]], //übersetze int aus DB zu String
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
          categories[key] == this.category), //übersetze String zu int für DB
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
