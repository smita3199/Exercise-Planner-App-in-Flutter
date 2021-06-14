import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:exercise_planner_app/models/exercise.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String exerciseTable = 'exercise_table';
  String colId = 'id';
  String colName = 'name';
  String colWeight = 'weight';
  String colSets = 'sets';
  String colReps = 'reps';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'exercises.db';

    var exercisesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return exercisesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    String sqlcreate = "CREATE TABLE $exerciseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colWeight TEXT, $colSets INTEGER, $colReps INTEGER)";
    await db.execute(sqlcreate);
  }

  Future<List<Map<String, dynamic>>> getExerciseMapList() async{
   Database db = await this.database;
   var result = await db.query(exerciseTable, orderBy: '$colId ASC');
   return result;
  }

  Future<int> insertExercise(Exercise exercise) async {
    Database db = await this.database;
    var result = await db.insert(exerciseTable, exercise.toMap());
    return result;
  }

  Future<int> updateExercise(Exercise exercise) async {
    var db = await this.database;
    var result = await db.update(exerciseTable, exercise.toMap(), where: '$colId = ?', whereArgs: [exercise.id]);
    return result;
  }

  Future<int> deleteExercise(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $exerciseTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $exerciseTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Exercise>> getExerciseList() async {
    var exerciseMapList = await getExerciseMapList();
    int count = exerciseMapList.length;
    List<Exercise> exerciseList = List<Exercise>();

    for (int i = 0; i < count; i++) {
      exerciseList.add(Exercise.fromMapObject(exerciseMapList[i]));
    }

    return exerciseList;
  }

}