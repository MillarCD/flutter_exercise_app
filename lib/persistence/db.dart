import 'package:sqflite/sqflite.dart';

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
                end_datetime DATETIME,
              )
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

  // TODO: registrar rutina;

  // TODO: obtener todas las rutinas
}