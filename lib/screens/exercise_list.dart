import 'package:flutter/material.dart';
import 'dart:async';
import 'package:exercise_planner_app/models/exercise.dart';
import 'package:exercise_planner_app/screens/exercise_detail.dart';
import 'package:exercise_planner_app/screens/curr_location.dart';
import 'package:exercise_planner_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {

  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {

    if(exerciseList == null){
      exerciseList = List<Exercise>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Planner"),
      ),

      body: getExerciseListView(),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.map),
            heroTag: 'map',
            onPressed: () {
              debugPrint("HelloActionButton");
              navigateToMap();
            },
          ),
          SizedBox(height: 10, width: 10),
          FloatingActionButton(
            heroTag: 'add',
            child: Icon(Icons.add),
            onPressed: () {
              debugPrint("HelloActionButton");
              navigateToDetail(Exercise('', 0, 0), "Add Exercise");
            },
          ),
        ],
      ),
    );
  }

  ListView getExerciseListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
        itemCount: count,
      itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.white,
            child : ListTile(
              leading: CircleAvatar(
                child: getWIcon(this.exerciseList[position].weight),
              ),
              title: Text(this.exerciseList[position].name, style: titleStyle),
              subtitle: Text("Sets:${this.exerciseList[position].sets} Reps:${this.exerciseList[position].reps} Weight:${this.exerciseList[position].weight}"),
              trailing: GestureDetector(
                child: Icon(Icons.check, color: Colors.black,),
                onTap: () {
                  _delete(context, this.exerciseList[position]);
                },
              ),
            onTap: () {
                debugPrint("HelloExer");
                navigateToDetail(this.exerciseList[position], "Edit Exercise");
            },
            )
          );
      },
    );
  }

  void navigateToDetail(Exercise exercise, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ExerciseDetail(exercise, title);
    }));

    if(result == true){
      updateListView();
    }
  }

  void navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CurrLoc()),
    );
  }

  Icon getWIcon(String weight){
    if(weight == null){
      return Icon(Icons.directions_run);
    }
    else{
      return Icon(Icons.fitness_center);
    }
  }

  void _delete(BuildContext context, Exercise exercise) async{
    int result = await databaseHelper.deleteExercise(exercise.id);
    if(result != 0){
      _showSnackBar(context, "Exercise Completed");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Exercise>> exerciseListFuture = databaseHelper.getExerciseList();
      exerciseListFuture.then((exerciseList){
        setState(() {
          this.exerciseList = exerciseList;
          this.count = exerciseList.length;
        });
      });
    });
  }

}
