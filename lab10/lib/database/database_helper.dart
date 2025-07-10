import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static  DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('college_student.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE college1 (
      college_id INTEGER PRIMARY KEY AUTOINCREMENT,
      college_name TEXT,
      degree TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE student1 (
      student_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      surname TEXT,
      college_id INTEGER,
      age INTEGER,
      twelfth_percentage REAL,
      tenth_percentage REAL,
      email TEXT,
      phone TEXT,
      FOREIGN KEY (college_id) REFERENCES college1 (college_id)
    )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}


