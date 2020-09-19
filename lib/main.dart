import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/jensb/GoogleDrive/Work/FlutterProjects/workouttracker/lib/screens/authenticate/authenticate.dart';
import 'file:///C:/Users/jensb/GoogleDrive/Work/FlutterProjects/workouttracker/lib/screens/home/home.dart';

import 'package:workouttracker/services/auth.dart';
import 'file:///C:/Users/jensb/GoogleDrive/Work/FlutterProjects/workouttracker/lib/shared/widgets/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Color.fromRGBO(79, 172, 254, 1),
        accentColor: Color.fromRGBO(249, 111, 92, 1),
      ),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Loading(
              scaffold: true,
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Loading(
            scaffold: true,
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: Consumer(
        builder: (context, AuthService user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Loading(scaffold: true);
            case Status.Unauthenticated:
              return Authenticate();
            case Status.Authenticated:
              return Home();
            default:
              return Home();
          }
        },
      ),
    );
  }
}
