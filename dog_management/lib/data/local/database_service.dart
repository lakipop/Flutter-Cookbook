import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/models/student.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  // In-memory storage for Web support
  final List<Student> _webMockDb = [];
  int _webIdCounter = 1;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database?> get database async {
    if (kIsWeb) return null; // No SQLite on Web
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'students_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        course TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertStudent(Student student) async {
    if (kIsWeb) {
      final newStudent = student.copyWith(id: _webIdCounter++);
      _webMockDb.add(newStudent);
      return newStudent.id!;
    }

    final db = await database;
    return await db!.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ
  Future<List<Student>> retrieveStudents() async {
    if (kIsWeb) {
      return List.from(_webMockDb);
    }

    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  // UPDATE
  Future<int> updateStudent(Student student) async {
    if (kIsWeb) {
      int index = _webMockDb.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        _webMockDb[index] = student;
        return 1;
      }
      return 0;
    }

    final db = await database;
    return await db!.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    if (kIsWeb) {
      _webMockDb.removeWhere((s) => s.id == id);
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
