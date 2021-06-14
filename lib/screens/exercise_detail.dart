import 'package:flutter/material.dart';
import 'dart:async';
import 'package:exercise_planner_app/models/exercise.dart';
import 'package:exercise_planner_app/utils/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ExerciseDetail extends StatefulWidget {

  final String appBarTitle;
  final Exercise exercise;
  ExerciseDetail(this.exercise, this.appBarTitle);

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState(this.exercise, this.appBarTitle);
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =  new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
  }
  Future _showNotification(String mssg) async {
    var androidDetails = new AndroidNotificationDetails("ID", "Exercise Planner App", "Exercise", importance: Importance.Low);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(androidDetails, iSODetails);

    await fltrNotification.show(0, "Exercise Planner App", mssg, generalNotificationDetails, payload: mssg);
  }

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Exercise exercise;

  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  _ExerciseDetailState(this.exercise, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    nameController.text = exercise.name;
    weightController.text = exercise.weight;
    setsController.text = exercise.sets.toString();
    repsController.text = exercise.reps.toString();

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),

        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[

              //Exercise Name ====================
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: TextField(
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint("name TextField");
                    updateName();
                  },
                  decoration: InputDecoration(
                    labelText: "Exercise Name",
                    labelStyle: textStyle,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              //Weight ====================
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: TextField(
                  controller: weightController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint("weight TextField");
                    updateWeight();
                  },
                  decoration: InputDecoration(
                    labelText: "Weight (Optional)",
                    labelStyle: textStyle,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              //Sets ====================
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: TextField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  style: textStyle,
                  onChanged: (value){
                    debugPrint("sets TextField");
                    updateSets();
                  },
                  decoration: InputDecoration(
                    labelText: "Sets",
                    labelStyle: textStyle,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              //Reps ====================
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  style: textStyle,
                  onChanged: (value){
                    debugPrint("reps TextField");
                    updateReps();
                  },
                  decoration: InputDecoration(
                    labelText: "Reps",
                    labelStyle: textStyle,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              //Save and Delete ====================
              Padding(
                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Row(
                  children: <Widget>[

                    //Save
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("SaveButton");
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(width: 5,),

                    //Delete
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Delete",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("DeleteButton");
                            _delete();
                          });
                        },
                      ),
                    ),

                  ],
                )
              ),

            ],
          ),
        ),

      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateName(){
    exercise.name = nameController.text;
  }

  void updateWeight(){
    exercise.weight = weightController.text;
  }

  void updateSets(){
    exercise.sets = int.parse(setsController.text);
  }

  void updateReps(){
    exercise.reps = int.parse(repsController.text);
  }

  void _save() async {
    moveToLastScreen();
    int result;

    if(exercise.id != null){
      result = await helper.updateExercise(exercise);
    }
    else{
      result = await helper.insertExercise(exercise);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Exercise Saved Successfully');
    }
    else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Exercise');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (exercise.id == null) {
      _showAlertDialog('Status', 'No Exercise was deleted');
      return;
    }

    int result = await helper.deleteExercise(exercise.id);
    if (result != 0) {
      //_showAlertDialog('Status', 'Exercise Deleted Successfully');
      _showNotification('Exercise Deleted Successfully');
    }
    else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Exercise');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}