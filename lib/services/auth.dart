import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workouttracker/services/database.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated }

class AuthService with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  //sign in with email and password (returns: FirebaseUser, if error: error message (String))
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      switch (e.code) {
        case ("ERROR_WRONG_PASSWORD"):
          return ("You entered the wrong password.");
        case ("ERROR_USER_NOT_FOUND"):
          return ("No user found with that email.");
        default:
          return (e.code);
      }
    }
  }

  //register with email and password (returns: FirebaseUser, if error: error message (String))
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid: user.uid).updateUserData(username);

      return user;
    } catch (e) {
      switch (e.code) {
        case ('ERROR_EMAIL_ALREADY_IN_USE'):
          return ('This email is already in use.');
        default:
          return (e.code);
      }
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
