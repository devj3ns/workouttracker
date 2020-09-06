import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/services/auth.dart';

import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/home/workoutCalendar.dart';
import 'account.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthService authService =  Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Hello dev.j3ns",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      CircleAvatar(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Account(authService: authService,))),
                          child: Text("J"),
                        ),
                        foregroundColor: Colors.blueAccent,
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
