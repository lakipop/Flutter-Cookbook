# ICT4153 Practical Exam — Master Guide
## Build a Full Flutter + SQLite App in 90 Minutes

---

## 1. THE EXAM PATTERN

Your Practical 10 activity IS the exam blueprint. Whatever entity they give you (Students, Products, Books, Patients, Employees, Tasks...), the app is always the same skeleton:

```
Form (Add) → SQLite Insert → ListView (Read) → Edit (pre-filled form, Update) → Delete (confirm dialog)
+ Validation + SnackBars
```

**Your job is NOT to think during the exam. It's to type a memorized template and rename ~6 words.**

---

## 2. TIME BUDGET (90 min)

| Time | Task | Notes |
|------|------|-------|
| 0–5 | `flutter create app`, edit pubspec.yaml, `flutter pub get`, start emulator | Start emulator FIRST — it boots while you type |
| 5–10 | Skeleton: main(), MyApp, empty StudentManager screen | Run once now — confirm it builds |
| 10–25 | Model class + 5 database functions | Pure muscle memory |
| 25–45 | Home screen: ListView.builder + FAB | Run + test with dummy insert |
| 45–65 | Add/Edit dialog form + validation | Biggest chunk |
| 65–75 | Delete confirmation + SnackBars | |
| 75–90 | Full test of all 4 CRUD ops, fix bugs, polish | NEVER skip testing time |

**Golden rule: run the app at 10 min, 45 min, 65 min — never write 80 minutes of code then run.**

---

## 3. SETUP (memorize)

```bash
flutter create student_manager
cd student_manager
```

**pubspec.yaml** — add under `dependencies:` (indentation matters — 2 spaces):

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4
  path: ^1.8.0
```

```bash
flutter pub get
flutter run
```

⚠️ **sqflite only works on Android/iOS emulator or real device — NOT Chrome/web.** Make sure you run on the Android emulator.

---

## 4. THE MASTER TEMPLATE (single file: lib/main.dart)

This is the complete Student Manager app exactly matching your Practical 10 activity (dialog form like the lab screenshot, validation, confirm-delete, SnackBars). It follows your lab sheet's function names (`initializeDB`, `toMap`, `fromMap`, `insertStudent`...) so it looks like your lecturer's style.

```dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

// ================= MODEL =================
class Student {
  final int? id;
  final String name;
  final int age;
  final String course;

  Student({this.id, required this.name, required this.age, required this.course});

  // Convert a Student into a Map (for insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'course': course,
    };
  }

  // Extract a Student object from a Map (for read)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      course: map['course'],
    );
  }
}

// ================= DATABASE =================
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
  await db.delete(
    'students',
    where: 'id = ?',
    whereArgs: [id],
  );
}

// ================= UI =================
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

  // READ: fetch all and rebuild UI
  Future<void> _refreshList() async {
    final data = await retrieveStudents();
    setState(() {
      _students = data;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // CREATE + UPDATE: one dialog for both (student == null means Add)
  void _showForm({Student? student}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: student?.name ?? '');
    final ageController =
        TextEditingController(text: student?.age.toString() ?? '');
    final courseController = TextEditingController(text: student?.course ?? '');

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
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Age must be a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course';
                  }
                  return null;
                },
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
                  await insertStudent(Student(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    course: courseController.text,
                  ));
                  _showMessage('Student Added');
                } else {
                  await updateStudent(Student(
                    id: student.id,
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    course: courseController.text,
                  ));
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

  // DELETE: confirmation dialog first
  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await deleteStudent(student.id!);
              Navigator.pop(context);
              _showMessage('Student Deleted');
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
          ? const Center(child: Text('No students yet. Tap + to add.'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('${student.age}, ${student.course}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(student: student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(student),
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
```

---

## 5. HOW TO ADAPT TO ANY EXAM QUESTION (the 6 renames)

If the exam says "Book Manager" or "Product Inventory", change ONLY these:

| Template | Example: Books | Example: Products |
|---|---|---|
| `Student` (class) | `Book` | `Product` |
| `students` (table) | `books` | `products` |
| `students_database.db` | `books_database.db` | `products_database.db` |
| fields: `name, age, course` | `title, author, price` | `name, price, quantity` |
| function names: `insertStudent`... | `insertBook`... | `insertProduct`... |
| labels: 'Name', 'Age', 'Course' | 'Title', 'Author', 'Price' | ... |

**Field type rules:**
- Text field → `String` in model, `TEXT` in CREATE TABLE, plain controller
- Number field → `int` in model, `INTEGER` in CREATE TABLE, `int.parse(controller.text)` + `keyboardType: TextInputType.number`
- Decimal (price) → `double` in model, `REAL` in CREATE TABLE, `double.parse(...)`

That's it. Everything else (dialog, validation pattern, confirm delete, refresh, snackbar) is identical.

---

## 6. VARIANT: SEPARATE SCREEN INSTEAD OF DIALOG

If the question explicitly requires "navigate to a second screen for Add/Edit" (Practical 09 navigation style), replace the dialog with this:

```dart
// On the home screen — open form screen and refresh when it returns:
onPressed: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => StudentFormScreen(student: null)),
  );
  _refreshList();
},
```

```dart
class StudentFormScreen extends StatefulWidget {
  final Student? student; // null = Add mode
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController courseController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student?.name ?? '');
    ageController =
        TextEditingController(text: widget.student?.age.toString() ?? '');
    courseController =
        TextEditingController(text: widget.student?.course ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // ... same 3 TextFormFields as the dialog version ...
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (widget.student == null) {
                      await insertStudent(Student(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        course: courseController.text,
                      ));
                    } else {
                      await updateStudent(Student(
                        id: widget.student!.id,
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        course: courseController.text,
                      ));
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 7. QUICK BOLT-ONS (extra marks, 5 min each)

Only add these AFTER core CRUD works:

**Search by name** (add above ListView in a Column):
```dart
TextField(
  decoration: const InputDecoration(labelText: 'Search', prefixIcon: Icon(Icons.search)),
  onChanged: (value) {
    setState(() {
      _filtered = _students
          .where((s) => s.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  },
),
```

**Dropdown for course** (replace course TextFormField):
```dart
DropdownButtonFormField<String>(
  value: selectedCourse,
  decoration: const InputDecoration(labelText: 'Course'),
  items: ['ICT', 'BST', 'ET']
      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
      .toList(),
  onChanged: (value) => selectedCourse = value,
  validator: (value) => value == null ? 'Please select course' : null,
),
```

**Fade-in list animation** (Practical 08 — wrap the ListView):
```dart
// In State class: with SingleTickerProviderStateMixin
late AnimationController _controller;
late Animation<double> _fadeAnimation;

// in initState():
_controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
_fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
_controller.forward();

// in dispose(): _controller.dispose();
// wrap body: FadeTransition(opacity: _fadeAnimation, child: ListView.builder(...))
```

**Long-press to delete** (Practical 09 gestures — on the ListTile):
```dart
ListTile(
  onLongPress: () => _confirmDelete(student),
  ...
)
```

---

## 8. COMMON ERRORS & INSTANT FIXES

| Error | Fix |
|---|---|
| `databaseFactory not initialized` / DB not working | You're running on Chrome/Windows. Run on **Android emulator** |
| `Undefined name 'join'` | Missing `import 'package:path/path.dart';` |
| `Undefined name 'ConflictAlgorithm'` | Missing `import 'package:sqflite/sqflite.dart';` |
| Red screen `type 'String' is not a subtype of 'int'` | You forgot `int.parse(ageController.text)` |
| List doesn't update after add/delete | You forgot `_refreshList()` after the operation, or forgot `setState` inside it |
| `Null check operator used on a null value` on delete | `student.id!` — record has no id; make sure you read from DB, not a hand-made object |
| Column overflow in dialog | Add `mainAxisSize: MainAxisSize.min` to the Column |
| `_formKey` already used error | Create the `GlobalKey<FormState>()` INSIDE `_showForm()`, not as a class field |
| pubspec error | Indentation: exactly 2 spaces under `dependencies:` |
| Nothing happens on SAVE | You forgot `formKey.currentState!.validate()` returns false on empty fields — check error texts on screen |

---

## 9. MEMORIZATION ORDER (tonight's plan)

Type the full app from scratch **twice** tonight, in this order — it builds dependency-first so the app compiles at every checkpoint:

1. **Round 1 (with guide open):** setup → model → 5 DB functions → home screen → dialog → delete. Run after each section. ~60 min.
2. **Round 2 (guide closed, peek only when stuck):** same order. Target ~45 min.
3. Before sleeping, write these from pure memory on paper (the parts people forget under pressure):
   - The 3 imports
   - `initializeDB()` (the `join` + `openDatabase` + `onCreate` shape)
   - `toMap()` / `fromMap()`
   - The validator pattern: `if (value == null || value.isEmpty) return '...'; return null;`

The UI code (Scaffold/ListTile/FAB) you already know cold from Practicals 06–07 — don't waste memory effort there. Your memorization budget goes to: **imports, DB layer, form key + validate, controller pre-fill (`student?.name ?? ''`)**.

---

## 10. EXAM-DAY CHECKLIST

- [ ] Start the emulator the second you sit down
- [ ] `flutter create` + pubspec + `pub get` before reading the question twice
- [ ] Read question → identify: entity name, fields + types, dialog vs screen form
- [ ] Type template, doing the 6 renames as you go
- [ ] Run at the checkpoints (10/45/65 min)
- [ ] Test all four: Add → see in list → Edit → Delete (with confirm)
- [ ] If something breaks at 80 min: comment out the broken extra, submit working CRUD. **A working basic app beats a broken fancy app.**
