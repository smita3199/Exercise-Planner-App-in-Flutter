import 'package:flutter/material.dart';
import 'package:exercise_planner_app/screens/exercise_list.dart';
import 'package:exercise_planner_app/screens/exercise_detail.dart';
import 'package:exercise_planner_app/screens/curr_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exercise Planner App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ExerciseList(),
    );
  }
}