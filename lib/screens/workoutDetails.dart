import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:workouttracker/models/workout.dart';
import 'package:workouttracker/services/database.dart';
import 'package:workouttracker/widgets/roundIconButton.dart';
import 'package:workouttracker/widgets/frostedBox.dart';
import 'package:workouttracker/widgets/mySlider.dart';
import 'package:workouttracker/shared/constants.dart';

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

  //form values
  String category;
  double duration;
  double intensity = 0; //0, 5 or 10
  double rating = 0; //0, 5 or 10
  String note = '';

  bool get isAddWorkoutScreen => widget.initialWorkoutData == null;
  String get dateStr => DateFormat.MMMEd().format(widget.dateTime);
  String get timeStr => DateFormat.Hm().format(widget.dateTime);

  @override
  void initState() {
    super.initState();

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

  void save({bool add}) async {
    Workout workout = Workout(
      uid: widget.initialWorkoutData == null
          ? null
          : widget.initialWorkoutData.uid,
      category: category,
      duration: duration.toInt(),
      intensity: intensity.toInt(),
      rating: rating.toInt(),
      note: note,
      timestamp: widget.dateTime,
    );

    add
        ? await widget.database.addWorkout(workout)
        : await widget.database.updateWorkout(workout);

    setState(() => disableSaveButton = true);
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
        if (duration > 0) {
          disableSaveButton = false;
        }
      });
    } else if (newIntensity != null) {
      setState(() {
        intensity = newIntensity;
        disableSaveButton = false;
      });
    } else if (newRating != null) {
      setState(() {
        rating = newRating;
        disableSaveButton = false;
      });
    } else if (category != null) {
      setState(() {
        category = newCategory;
        disableSaveButton = false;
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
                          Container(
                            height: MediaQuery.of(context).size.width * 0.14,
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: FrostedBox(
                              customColor: Colors.blue.withOpacity(0.9),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
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
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          isAddWorkoutScreen
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  child: FrostedBox(
                                    onTap: () {
                                      widget.database.deleteWorkout(
                                        Workout(
                                            uid: widget.initialWorkoutData.uid),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    customColor: Colors.grey.withOpacity(0.8),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        isAddWorkoutScreen ? "Track Workout" : "Edit Workout",
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
                          icon: isAddWorkoutScreen ? Icons.add : Icons.save,
                          onTap: () {
                            if (isAddWorkoutScreen) {
                              save(add: true);
                              Navigator.pop(context);
                            } else {
                              save(add: false);
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
