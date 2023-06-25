import 'package:eapp/models/training.dart';
import 'package:sqflite/sqflite.dart';

import 'package:eapp/models/exercise.dart';
import 'package:eapp/models/series.dart';

class DB {

  Database? _database;

  DB._();

  static final DB _db = DB._internal();
  
  factory DB() {
    return _db;
  }
  DB._internal();

  Future<void> initDB() async {
    final databasesPath = await getDatabasesPath();
    final String path = '$databasesPath/training.db';
  
    _database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE Exercise (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)'
        );
        await db.execute(
          '''
              CREATE TABLE Series (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                id_exercise INTEGER,
                id_training INTEGER,
                weight REAL,
                repetitions INTEGER,
                FOREIGN KEY(id_exercise) REFERENCES Exercise(id)
              )
          '''
        );

        await db.execute(
          '''
              CREATE TABLE Training (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                start_datetime DATETIME,
                end_datetime DATETIME
              )
          '''
        );

        await db.rawInsert(
          '''
              INSERT INTO Exercise (name) VALUES
              ("Curd de biceps"),
              ("Press de banca"),
              ("Press militar"),
              ("Sentadillas")
          '''
        );

      }
    );
  }

  Future<Database> get database async {
    if (_database!=null) return _database!;

    await initDB();
    return _database!;
  }

  Future<List<Exercise>> getExercises() async {
    final Database db = await database;
    final res = await db.rawQuery('SELECT * FROM Exercise');

    return [ ...res.map((e) => Exercise.fromMap(e))];
  }

  Future<int> createTraining(List<Series> series, DateTime start, DateTime end) async {
    final Database db = await database;

    final int idTraining = await db.transaction((txn) async {
      final int idTraining = await txn.rawInsert(
        """
          INSERT INTO Training (start_datetime, end_datetime) VALUES
          (?, ?)
        """,
        [start.toString(), end.toString()]
      );

      final batch = txn.batch();
      for (Series s in series) {
        batch.rawInsert(
          """
            INSERT INTO Series (id_training, id_exercise, weight, repetitions) VALUES
            (?, ?, ?, ?)
          """,
          [idTraining, s.idExercise, s.weight, s.repetitions]
        );
      }
      await batch.commit();
      return idTraining;
    });

    print("Se registro la rutina: $idTraining");
    return idTraining;
  }

  Future<List<Training>> getTrainings() async {
    final Database db = await database;
    List<Map<String, Object?>> res = await db.rawQuery("SELECT * FROM Training");
    print("se obtuvieron los entrenamientos");
    
    return [ ...res.map((t) => Training.fromMap(t)) ];
  }
  
  Future<List<Series>> getSeriesByIdTraining(int idTraining) async {
    final Database db = await database;
    List<Map<String, Object?>> res = await db.rawQuery("SELECT * FROM Series WHERE id_training=?", [idTraining]);
    print("se obtuvieron las series");

    return [ ...res.map((t) => Series.fromMap(t)) ];
  }

}