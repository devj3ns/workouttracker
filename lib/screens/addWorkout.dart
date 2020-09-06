import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/constants.dart';

class AddWorkout extends StatefulWidget {
  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _formKey = GlobalKey<FormState>();

  // text field states
  String name = '';
  String description = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    DatabaseService _database = DatabaseService(uid: user.uid);

    void addWorkout() async {
      _formKey.currentState.reset();

      Workout workout = Workout(
          name: name, description: description, timestamp: DateTime.now());

      await _database.addWorkout(workout);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Workout")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(child: SizedBox()),
              SizedBox(height: 50.0),
              Text(
                "Add Workout",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    hintText: 'Name/Title', prefixIcon: Icon(Icons.title)),
                validator: (val) => val.isEmpty ? 'Please enter a title' : null,
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.short_text),
                ),
                maxLines: 5,
                validator: (val) =>
                    val.isEmpty ? 'Please enter a description' : null,
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    addWorkout();
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
                      Icons.add,
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
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
