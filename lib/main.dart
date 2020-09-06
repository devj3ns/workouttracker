import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/screens/wrapper.dart';
import 'package:workouttracker/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.varelaRoundTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: Color.fromRGBO(79, 172, 254, 1),
          accentColor: Color.fromRGBO(249, 111, 92, 1),
        ),
        home: Wrapper(),
      ),
    );
  }
}
