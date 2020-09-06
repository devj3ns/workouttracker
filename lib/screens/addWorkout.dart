import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/auth.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/widgets/addButton.dart';
import 'package:workouttracker/widgets/mySlider.dart';
import 'package:workouttracker/constants.dart';

class AddWorkout extends StatefulWidget {
  final DateTime dateTime;
  final FirebaseUser user;

  AddWorkout({
    @required this.dateTime,
    @required this.user,
  });
  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _formKey = GlobalKey<FormState>();

  // text field states
  String category; //muss so initialisiert werden!
  double duration;
  double intensity; //1-3
  double rating; //1-3 (Emojis in UI)
  String note = '';

  @override
  Widget build(BuildContext context) {
    DatabaseService _database = DatabaseService(uid: widget.user.uid);
    FocusNode noteFocusNote = new FocusNode();

    void addWorkout() async {
      Workout workout = Workout(
        category: category,
        duration: duration.toInt(),
        intensity: intensity.toInt(),
        rating: rating.toInt(),
        note: note,
        timestamp: widget.dateTime,
      );

      print(workout.toDocument());

      await _database.addWorkout(workout);
    }

    bool isFormValid() {
      if (duration != null &&
          intensity != null &&
          rating != null &&
          duration != 0 &&
          category != null) {
        return true;
      }
      return false;
    }

    void changeDuration(double newDuration) {
      setState(() {
        print(newDuration);
        duration = newDuration;
      });
    }

    void changeIntensity(double newIntensity) {
      setState(() {
        intensity = newIntensity;
      });
    }

    void changeRating(double newRating) {
      setState(() {
        rating = newRating;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Workout")),
      body: GestureDetector(
        onTap: noteFocusNote.unfocus,
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
              children: <Widget>[
                SizedBox(height: 50.0),
                Text(
                  "Add Workout",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                Text(
                  "Date: " + DateFormat.MMMEd().format(widget.dateTime),
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  //onSaved: (val) => savedCategory = val,
                  value: category,
                  items: categories.values.map<DropdownMenuItem<String>>(
                    (String val) {
                      return DropdownMenuItem(
                        child: Text(val),
                        value: val,
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(() {
                      category = val;
                    });
                  },
                  validator: (val) =>
                      val == null ? 'Please choose a category' : null,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Category', prefixIcon: Icon(Icons.category)),
                ),
                SizedBox(height: 10.0),
                MySlider(
                  min: 0,
                  max: 60,
                  divisions: 12,
                  icon: Icons.timelapse,
                  text: "min",
                  changeValue: changeDuration,
                  isDurationSlider:
                      true, //damit es Rechteckig wird und 'min' nach Zahl hat
                ),
                SizedBox(height: 10.0),
                MySlider(
                  min: 1,
                  max: 3,
                  divisions: 2,
                  icon: FontAwesomeIcons.dumbbell,
                  text: "Intensity",
                  changeValue: changeIntensity,
                  isIntensitySlider: true,
                ),
                SizedBox(height: 10.0),
                MySlider(
                  min: 1,
                  max: 3,
                  divisions: 2,
                  icon: FontAwesomeIcons.smile,
                  text: "Rating",
                  changeValue: changeRating,
                  isRatingSlider: true,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  focusNode: noteFocusNote,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Note',
                    prefixIcon: Icon(FontAwesomeIcons.stickyNote),
                  ),
                  onChanged: (val) {
                    setState(() {
                      note = val;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                Center(
                  child: AddButton(
                    onTap: () {
                      addWorkout();
                      Navigator.pop(context);
                    },
                    disable: !isFormValid(),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
