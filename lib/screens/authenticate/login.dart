import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workouttracker/shared/constants.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/widgets/background.dart';
import 'package:workouttracker/widgets/loading.dart';

class SignIn extends StatefulWidget {
  final toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Background(),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Expanded(child: SizedBox()),
                        SizedBox(height: 50.0),
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email)),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              setState(() => loading = false);

                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with those credentials';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(20, 202, 201, 1),
                                  Color.fromRGBO(35, 233, 160, 1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: widget.toggleView,
                          child: Text(
                            "rather Register",
                            textAlign: TextAlign.start,
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
              ],
            ),
          );
  }
}
