import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/models/userData.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/constants.dart';

class Account extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    DatabaseService _database = DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: StreamBuilder<UserData>(
        stream: _database.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return SizedBox.expand(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.person_pin,
                      size: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userData.username,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    RaisedButton(
                      onPressed: _auth.signOut,
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
