import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/models/userData.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/widgets/loading.dart';

class Account extends StatelessWidget {

  final AuthService authService;

  Account({@required this.authService});

  @override
  Widget build(BuildContext context) {
    DatabaseService _database = DatabaseService(uid: authService.user.uid);

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
                      onPressed: (){
                        authService.signOut();
                        Navigator.of(context).pop();
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
