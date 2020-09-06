import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final username;

  UserData({this.username});

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      username: doc["username"],
    );
  }
}
