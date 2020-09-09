import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/models/userData.dart';

import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/frostedBox.dart';
import 'package:workouttracker/widgets/home/workoutCalendar.dart';
import 'package:workouttracker/widgets/loading.dart';
import 'account.dart';

class Home extends StatelessWidget {
  void openAccountScreen(BuildContext context, AuthService authService) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Account(
          authService: authService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    DatabaseService database = DatabaseService(uid: authService.user.uid);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<UserData>(
                        stream: database.userData,
                        builder: (context, snapshot) {
                          String username = "";
                          if (snapshot.hasData) {
                            username = snapshot.data.username;
                          }

                          return Text(
                            "Hello " + username,
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          );
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.11,
                        width: MediaQuery.of(context).size.width * 0.11,
                        child: FrostedBox(
                          colorHighlight: true,
                          onTap: () => openAccountScreen(context, authService),
                          borderRadius: 100,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  WorkoutCalendar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
