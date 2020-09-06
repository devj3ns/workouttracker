import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/authenticate/authenticate.dart';

import 'package:workouttracker/screens/navBar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    //return either Home (TabBar) or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return NavBar();
    }
  }
}
