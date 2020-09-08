import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/shared/constants.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/shared/ensureVisibleWhenFocused.dart';
import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/loading.dart';
import 'package:workouttracker/widgets/roundIconButton.dart';
import 'package:workouttracker/shared/widgetExtensions.dart';

enum AuthType { Login, Register }

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field states
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  FocusNode focusNodeUsername = new FocusNode();
  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();

  AuthType authType = AuthType.Login;

  void onButtonTab(AuthService auth) async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);

      dynamic result;

      if (authType == AuthType.Register) {
        result =
            await auth.registerWithEmailAndPassword(email, password, username);
      } else {
        result = await auth.signInWithEmailAndPassword(email, password);
      }

      if (result is! FirebaseUser) {
        //if an error occured

        setState(() {
          loading = false;
          error = result;
        });
      }
    }
  }

  void toggleAuthType() {
    if (authType == AuthType.Login) {
      setState(() {
        authType = AuthType.Register;
      });
    } else {
      setState(() {
        authType = AuthType.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: height * 0.3,
                  ),
                  Text(
                    authType == AuthType.Login ? "Login" : "Register",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 150),
                    crossFadeState: authType == AuthType.Register
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (val) =>
                          val.trim().isEmpty ? 'Enter your name' : null,
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
                    ).addPaddingTop(30),
                    secondChild: SizedBox(),
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (val) =>
                        val.trim().isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ).addPaddingTop(10),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (val) => val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ).addPaddingTop(10),
                  Center(
                    child: RoundIconButton(
                      icon: authType == AuthType.Login
                          ? Icons.arrow_forward
                          : Icons.check,
                      onTap: () => onButtonTab(_auth),
                    ).addPaddingTop(15),
                  ),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
                  ).addPaddingTop(12),
                  SizedBox(
                    height: authType == AuthType.Login
                        ? height * 0.202
                        : height * 0.1,
                  ),
                  GestureDetector(
                    onTap: toggleAuthType,
                    child: Text(
                      "rather " +
                          (authType != AuthType.Login ? "Login" : "Register"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading
            ? Loading(
                scaffold: false,
              )
            : SizedBox(),
      ],
    );
  }
}
