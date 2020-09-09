import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:workouttracker/shared/constants.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/loading.dart';
import 'package:workouttracker/widgets/roundIconButton.dart';
import 'package:workouttracker/shared/widgetExtensions.dart';
import 'package:workouttracker/shared/stringExtensions.dart';

enum AuthType { Login, Register }

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //we need them because then on _formKey.reset() only the name field (without) controller gets resetted when the authType changes!
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //text field states
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  AuthType authType = AuthType.Login;

  void onRegisterSaveButtonTap(AuthService auth) async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);

      dynamic result;

      if (authType == AuthType.Register) {
        result =
            await auth.registerWithEmailAndPassword(email, password, username);
      } else {
        result = await auth.signInWithEmailAndPassword(email, password);
      }

      if (result is! User) {
        //if an error occured
        setState(() {
          loading = false;
          error = result;
        });
      }
    }
  }

  void onGoogleSignInButtonTap(AuthService auth) async {
    setState(() => loading = true);

    dynamic result;

    result = await auth.signInWithGoogle();

    if (result is! User) {
      //if an error occured
      setState(() {
        loading = false;
        error = result;
      });
    }
  }

  void toggleAuthType() {
    if (authType == AuthType.Login) {
      setState(() {
        _formKey.currentState.reset();
        error = "";
        authType = AuthType.Register;
      });
    } else {
      setState(() {
        _formKey.currentState.reset();
        error = "";
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
          body: Form(
            key: _formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              children: [
                SizedBox(
                  height: height * 0.3,
                ),
                Text(
                  authType == AuthType.Register ? "Register" : "Login",
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
                    validator: authType == AuthType.Register
                        ? (val) =>
                            val.trim().isEmpty ? 'Please enter your name' : null
                        : null,
                    onChanged: (val) {
                      setState(() {
                        username = val;
                      });
                    },
                    enabled: authType == AuthType.Register,
                  ),
                  secondChild: SizedBox(),
                ).addPaddingTop(30),
                TextFormField(
                  controller: emailController,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (val) =>
                      !val.isEmail() ? 'Please enter a valid email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ).addPaddingTop(10),
                TextFormField(
                  controller: passwordController,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (val) => val.length < 6
                      ? 'Please enter a password 6+ chars long'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ).addPaddingTop(10),
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 150),
                  crossFadeState: error == ""
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Center(
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ).addPaddingTop(15),
                  ),
                  secondChild: SizedBox(),
                ),
                Center(
                  child: RoundIconButton(
                    iconWidget: AnimatedCrossFade(
                      duration: Duration(milliseconds: 150),
                      crossFadeState: authType == AuthType.Register
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Icon(
                        Icons.arrow_forward,
                        size: 30,
                        color: Colors.white,
                      ),
                      secondChild: Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => onRegisterSaveButtonTap(_auth),
                  ),
                ).addPaddingTop(15),
              ],
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ).addPaddingBottom(4),
              SignInButton(
                Buttons.Google,
                text: "Login with Google",
                onPressed: () => onGoogleSignInButtonTap(_auth),
              ).addPaddingBottom(8),
            ],
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
