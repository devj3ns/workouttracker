import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/models/userData.dart';
import 'package:workouttracker/screens/account/account.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/widgets/background.dart';
import 'package:workouttracker/shared/widgets/frostedBox.dart';

import 'widgets/workoutCalendar.dart';

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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.13,
                    child: Row(
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
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            );
                          },
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.11,
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: FrostedBox(
                            colorHighlight: true,
                            onTap: () =>
                                openAccountScreen(context, authService),
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
                  ),
                  SizedBox(
                    height: height * 0.81,
                    child: WorkoutCalendar(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
