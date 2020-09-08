import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/frostedBox.dart';
import 'package:workouttracker/widgets/home/workoutCalendar.dart';
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
                      Text(
                        "Hello dev.j3ns",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: FrostedBox(
                          customColor: Color.fromRGBO(9, 234, 254, 0.4),
                          onTap: () => openAccountScreen(context, authService),
                          borderRadius: 100,
                          child: Center(
                            child: Text(
                              "J",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
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
