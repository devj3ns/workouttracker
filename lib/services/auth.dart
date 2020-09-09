import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated }

class AuthService with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  //sign in with email and password (returns: User, if error: error message (String))
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      return user;
    } catch (e) {
      switch (e.code) {
        case ("ERROR_WRONG_PASSWORD"):
          return ("Incorrect password. Please try again");
        case ("ERROR_USER_NOT_FOUND"):
          return ("No user found with that email.");
        default:
          return (e.code);
      }
    }
  }

  //register with email and password (returns: User, if error: error message (String))
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

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

  //signs in with google (and registers if new account) (returns: User, if error: error message (String))
  Future<dynamic> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //get the UserCredential
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User user = result.user;
      bool isNewUser = result.additionalUserInfo.isNewUser;

      //if new user (not registered yet) create a UserData document in the database
      if (isNewUser) {
        await DatabaseService(uid: user.uid).updateUserData(user.displayName);
      }

      return user;
    } catch (e) {
      return (e.code);
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
