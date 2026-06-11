import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ============================================================
// HOW TO USE THIS FILE:
// 1. Copy this entire file into your lib/main.dart
// 2. Do the 6 renames listed below:
//    - "Student"          → your entity (e.g. Book, Product)
//    - "students"         → table name  (e.g. books, products)
//    - "students_database.db" → db name (e.g. books_database.db)
//    - "name, age, course"→ your fields (e.g. title, author, price)
//    - "insertStudent"    → insertBook / insertProduct
//    - label texts 'Name','Age','Course' → your field labels
// ============================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentManager(),
    );
  }
}

// ================== MODEL ==================
class Student {
  final int? id;
  final String name;
  final int age;
  final String course;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'course': course};
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      course: map['course'],
    );
  }
}

// ================== DATABASE ==================
Future<Database> initializeDB() async {
  String path = join(await getDatabasesPath(), 'students_database.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, course TEXT)',
      );
    },
    version: 1,
  );
}

Future<void> insertStudent(Student student) async {
  final db = await initializeDB();
  await db.insert(
    'students',
    student.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Student>> retrieveStudents() async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.query('students');
  return queryResult.map((e) => Student.fromMap(e)).toList();
}

Future<void> updateStudent(Student student) async {
  final db = await initializeDB();
  await db.update(
    'students',
    student.toMap(),
    where: 'id = ?',
    whereArgs: [student.id],
  );
}

Future<void> deleteStudent(int id) async {
  final db = await initializeDB();
  await db.delete('students', where: 'id = ?', whereArgs: [id]);
}

// ================== UI ==================
class StudentManager extends StatefulWidget {
  const StudentManager({super.key});
  @override
  State<StudentManager> createState() => _StudentManagerState();
}

class _StudentManagerState extends State<StudentManager> {
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final data = await retrieveStudents();
    setState(() {
      _students = data;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showForm({Student? student}) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final ageCtrl = TextEditingController(text: student?.age.toString() ?? '');
    final courseCtrl = TextEditingController(text: student?.course ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter name' : null,
              ),
              TextFormField(
                controller: ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter age';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              TextFormField(
                controller: courseCtrl,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter course' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (student == null) {
                  await insertStudent(
                    Student(
                      name: nameCtrl.text,
                      age: int.parse(ageCtrl.text),
                      course: courseCtrl.text,
                    ),
                  );
                  _showMessage('Student Added');
                } else {
                  await updateStudent(
                    Student(
                      id: student.id,
                      name: nameCtrl.text,
                      age: int.parse(ageCtrl.text),
                      course: courseCtrl.text,
                    ),
                  );
                  _showMessage('Student Updated');
                }
                Navigator.pop(context);
                _refreshList();
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await deleteStudent(student.id!);
              Navigator.pop(context);
              _showMessage('Deleted');
              _refreshList();
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Manager'),
        backgroundColor: Colors.blue,
      ),
      body: _students.isEmpty
          ? const Center(child: Text('No students. Tap + to add.'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final s = _students[index];
                return ListTile(
                  title: Text(s.name),
                  subtitle: Text('Age: ${s.age} | Course: ${s.course}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(student: s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(s),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
