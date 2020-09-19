import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/shared/constants.dart';
import 'package:workouttracker/shared/extensions/widgetExtensions.dart';
import 'package:workouttracker/shared/widgets/frostedBox.dart';
import 'package:workouttracker/shared/widgets/roundIconButton.dart';

import 'widgets/RoundedSquareButton.dart';
import 'widgets/mySlider.dart';

enum ScreenType { AddWorkout, ViewWorkout }

class WorkoutDetails extends StatefulWidget {
  final DateTime dateTime;
  final DatabaseService database;
  final Workout initialWorkoutData;

  WorkoutDetails({
    @required this.dateTime,
    @required this.database,
    this.initialWorkoutData,
  });
  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  final _formKey = GlobalKey<FormState>();
  bool disableSaveButton = true;
  FocusNode noteFocusNote = new FocusNode();

  String category;
  double duration;
  double intensity = 0; //0, 5 or 10
  double rating = 0; //0, 5 or 10
  String note = '';
  DateTime timestamp;

  ScreenType screenType;
  String get dateStr => DateFormat.MMMEd().format(timestamp);
  String get timeStr => DateFormat.Hm().format(timestamp);

  @override
  void initState() {
    super.initState();

    screenType = widget.initialWorkoutData == null
        ? ScreenType.AddWorkout
        : ScreenType.ViewWorkout;

    if (screenType == ScreenType.AddWorkout) {
      //todo: if widget.dateTime is not today show a time picker to select time
      timestamp = DateTime(
        widget.dateTime.year,
        widget.dateTime.month,
        widget.dateTime.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );
    } else {
      timestamp = widget.dateTime;
    }

    if (widget.initialWorkoutData != null) {
      initFormValues();
    }
  }

  void initFormValues() {
    category = widget.initialWorkoutData.category;
    duration = widget.initialWorkoutData.duration.toDouble();
    intensity = widget.initialWorkoutData.intensity.toDouble();
    rating = widget.initialWorkoutData.rating.toDouble();
    note = widget.initialWorkoutData.note;
  }

  void save() async {
    if (!isFormValid()) {
      throw "Form is not valid but save button was pressed!";
    }

    if (screenType == ScreenType.AddWorkout) {
      //add new workout

      Workout workout = Workout(
        category: category,
        duration: duration.toInt(),
        intensity: intensity.toInt(),
        rating: rating.toInt(),
        note: note,
        timestamp: timestamp,
      );

      await widget.database.addWorkout(workout);
    } else {
      //update existing workout

      Workout workout = Workout(
        uid: widget.initialWorkoutData.uid,
        category: category,
        duration: duration.toInt(),
        intensity: intensity.toInt(),
        rating: rating.toInt(),
        note: note,
      );

      await widget.database.updateWorkout(workout);
    }

    setState(() => disableSaveButton = true);
  }

  bool isFormValid() {
    return duration != null &&
        intensity != null &&
        category != null &&
        rating != null;
  }

  //the slider widgets use this method to provide their values to this stateful widget
  void setFormValues(
      {double newDuration,
      double newIntensity,
      double newRating,
      String newCategory}) {
    if (newDuration != null) {
      setState(() {
        duration = newDuration;
        disableSaveButton = isFormValid() ? false : true;
      });
    } else if (newIntensity != null) {
      setState(() {
        intensity = newIntensity;
        disableSaveButton = isFormValid() ? false : true;
      });
    } else if (newRating != null) {
      setState(() {
        rating = newRating;
        disableSaveButton = isFormValid() ? false : true;
      });
    } else if (newCategory != null) {
      setState(() {
        category = newCategory;
        disableSaveButton = isFormValid() ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          FrostedBox(
            borderRadius: 0,
            child: SizedBox.expand(),
            colorHighlight: true,
          ),
          SafeArea(
            child: GestureDetector(
              onTap: noteFocusNote.unfocus,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedSquareButton(
                            icon: Icons.arrow_back_ios,
                            onTap: Navigator.of(context).pop,
                            color: Colors.blue,
                          ),
                          Column(
                            children: [
                              Text(
                                dateStr,
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7),
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7),
                                ),
                              ).withPadding(top: 5),
                            ],
                          ),
                          screenType == ScreenType.AddWorkout
                              ? RoundedSquareButton(
                                  icon: Icons.info_outline,
                                  onTap: () => {},
                                  color: Colors.grey,
                                )
                              : RoundedSquareButton(
                                  icon: Icons.delete,
                                  onTap: () {
                                    widget.database.deleteWorkout(
                                      Workout(
                                          uid: widget.initialWorkoutData.uid),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  color: Colors.redAccent,
                                ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        screenType == ScreenType.AddWorkout
                            ? "Track Workout"
                            : "Edit Workout",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 60.0),
                      DropdownButtonFormField<String>(
                        value: category,
                        items: categories.values.map<DropdownMenuItem<String>>(
                          (String val) {
                            return DropdownMenuItem(
                              child: Text(val),
                              value: val,
                            );
                          },
                        ).toList(),
                        onChanged: (newCategory) =>
                            setFormValues(newCategory: newCategory),
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Category',
                            prefixIcon: Icon(Icons.category)),
                      ),
                      SizedBox(height: 10.0),
                      MySlider(
                        min: 0,
                        max: 60,
                        divisions: 12,
                        icon: Icons.timelapse,
                        text: "min",
                        changeValue: (newDuration) =>
                            setFormValues(newDuration: newDuration),
                        isDurationSlider:
                            true, //damit es Rechteckig wird und 'min' nach Zahl hat
                        initialValue:
                            widget.initialWorkoutData != null ? duration : null,
                      ),
                      SizedBox(height: 10.0),
                      MySlider(
                        min: 0,
                        max: 10,
                        divisions: 2,
                        icon: FontAwesomeIcons.dumbbell,
                        text: "Intensity",
                        changeValue: (newIntensity) =>
                            setFormValues(newIntensity: newIntensity),
                        isIntensitySlider: true,
                        initialValue: widget.initialWorkoutData != null
                            ? intensity
                            : null,
                      ),
                      SizedBox(height: 10.0),
                      MySlider(
                        min: 0,
                        max: 10,
                        divisions: 2,
                        icon: FontAwesomeIcons.smile,
                        text: "Rating",
                        changeValue: (newRating) =>
                            setFormValues(newRating: newRating),
                        isRatingSlider: true,
                        initialValue:
                            widget.initialWorkoutData != null ? rating : null,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: note,
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
                      SizedBox(height: 25.0),
                      Center(
                        child: RoundIconButton(
                          heroTag: "TransitionWithWorkoutDetailScreen",
                          icon: screenType == ScreenType.AddWorkout
                              ? Icons.add
                              : Icons.save,
                          onTap: () {
                            save();

                            if (screenType == ScreenType.AddWorkout) {
                              Navigator.pop(context);
                            }
                          },
                          disable: disableSaveButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
