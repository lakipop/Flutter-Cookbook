# 🎯 ICT4153 Flutter Exam — QUICK GUIDE (2-Hour Study)
> **You know Java & other frameworks. You just need Flutter syntax. Focus here.**

---

## 🔥 WHAT WILL MOST LIKELY COME

Based on your practicals, **90% chance the exam is one of these two:**

### Option A — SQLite CRUD App (Practical 10 style) ⭐ MOST LIKELY
> "Build a [Student/Product/Book/Patient] Manager app with Add, View, Edit, Delete using SQLite"

### Option B — Multi-Screen UI App (Practical 07 style)
> "Build a [Food/Product/Event] listing app with a home grid, detail screen, and cart/list screen"

### Option C — Mix (both): Navigation + SQLite CRUD
> Template fill-in question: they give code with blanks — you fill `______`

---

## ⚡ PART 1: SQLITE CRUD APP — The Template (Memorize This)

> **The ONLY thing that changes between "Student Manager" and "Book Manager" is ~6 words.**

### Step 1 — pubspec.yaml (add 2 lines)
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4   # ← ADD THIS
  path: ^1.8.0         # ← ADD THIS
```

### Step 2 — Imports (top of main.dart)
```dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
```

### Step 3 — Model Class
```dart
class Student {
  final int? id;         // int? because DB auto-assigns it
  final String name;
  final int age;
  final String course;

  Student({this.id, required this.name, required this.age, required this.course});

  // Dart object → Map (for saving to DB)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'course': course};
  }

  // Map from DB → Dart object
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      course: map['course'],
    );
  }
}
```

### Step 4 — Database Functions (5 functions, memorize the pattern)
```dart
// OPEN / CREATE DATABASE
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

// INSERT
Future<void> insertStudent(Student student) async {
  final db = await initializeDB();
  await db.insert('students', student.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

// READ ALL
Future<List<Student>> retrieveStudents() async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.query('students');
  return queryResult.map((e) => Student.fromMap(e)).toList();
}

// UPDATE
Future<void> updateStudent(Student student) async {
  final db = await initializeDB();
  await db.update('students', student.toMap(), where: 'id = ?', whereArgs: [student.id]);
}

// DELETE
Future<void> deleteStudent(int id) async {
  final db = await initializeDB();
  await db.delete('students', where: 'id = ?', whereArgs: [id]);
}
```

### Step 5 — Full UI (StatefulWidget + ListView + FAB + Dialog)
```dart
void main() => runApp(const MyApp());

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
    _refreshList(); // load data when screen opens
  }

  // Fetch from DB and rebuild UI
  Future<void> _refreshList() async {
    final data = await retrieveStudents();
    setState(() { _students = data; });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ADD + EDIT in one dialog (student == null = Add mode)
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
            mainAxisSize: MainAxisSize.min, // IMPORTANT — stops overflow
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
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
                validator: (v) => (v == null || v.isEmpty) ? 'Enter course' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (student == null) {
                  await insertStudent(Student(name: nameCtrl.text, age: int.parse(ageCtrl.text), course: courseCtrl.text));
                  _showMessage('Student Added');
                } else {
                  await updateStudent(Student(id: student.id, name: nameCtrl.text, age: int.parse(ageCtrl.text), course: courseCtrl.text));
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

  // DELETE with confirmation dialog
  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete ${student.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
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
      appBar: AppBar(title: const Text('Student Manager'), backgroundColor: Colors.blue),
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
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(student: s)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(s)),
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

## ⚡ PART 2: MULTI-SCREEN UI APP — Practical 07 Key Concepts

> If they give you a navigation/layout question instead, here are the key code pieces.

### Navigator (go to another screen)
```dart
// PUSH (go to new screen)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailScreen(item: myItem)),
);

// POP (go back)
Navigator.pop(context);
```

### GridView (show items in a grid)
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,       // 2 columns
    crossAxisSpacing: 8.0,
    mainAxisSpacing: 8.0,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Card(
      child: Column(
        children: [
          Image.network(items[index].image),
          Text(items[index].name),
          Text('LKR ${items[index].price}'),
        ],
      ),
    );
  },
)
```

### Stack + Positioned (overlay badge on image)
```dart
Stack(
  children: [
    Image.network('image_url'),
    Positioned(
      top: 8,
      right: 8,
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(4),
        child: const Text('20% OFF', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)
```

### setState (update UI after change)
```dart
// Always wrap state changes in setState
setState(() {
  cartCount++;        // or list.add(item), or list.remove(item)
});
```

### Data Model (Practical 07 style)
```dart
class FoodItem {
  final String name;
  final double price;
  final String image;
  FoodItem({required this.name, required this.price, required this.image});
}

// Sample list
List<FoodItem> foodItems = [
  FoodItem(name: 'Rice & Curry', price: 250.0, image: 'https://...'),
  FoodItem(name: 'Kottu', price: 350.0, image: 'https://...'),
  // ... 4 more
];
```

---

## 🔄 HOW TO ADAPT TO ANY ENTITY (The 6 Renames)

| SQLite Template | Book Manager | Product Manager |
|---|---|---|
| `Student` class | `Book` | `Product` |
| `students` table | `books` | `products` |
| `students_database.db` | `books_database.db` | `products_database.db` |
| `name, age, course` | `title, author, price` | `name, price, qty` |
| `insertStudent(...)` | `insertBook(...)` | `insertProduct(...)` |

**Field type rules (don't mix these up):**
- `String` in Dart → `TEXT` in SQL → plain TextFormField
- `int` in Dart → `INTEGER` in SQL → `int.parse(ctrl.text)` + `keyboardType: TextInputType.number`
- `double` in Dart → `REAL` in SQL → `double.parse(ctrl.text)` + `keyboardType: TextInputType.number`

---

## 🚨 COMMON BUGS & FIXES

| What you see | What went wrong | Fix |
|---|---|---|
| DB not working, blank screen | Running on Chrome/Web | Run on **Android emulator** only |
| `Undefined 'join'` | Missing path import | `import 'package:path/path.dart';` |
| List doesn't update after add/delete | Forgot `_refreshList()` | Call `_refreshList()` after every DB operation |
| Red screen: `'String' not subtype of 'int'` | Forgot int.parse | `int.parse(ageCtrl.text)` |
| Column overflowing in dialog | Missing mainAxisSize | `mainAxisSize: MainAxisSize.min` on the Column |
| Nothing happens on SAVE | Form validation failing | Check if validator is returning an error message (look at the fields on screen) |
| `Null check on null value` on delete | `id` is null | Make sure you pass the full object loaded from DB, not hand-made |

---

## ⏱️ 90-MINUTE EXAM PLAN

```
0–5 min   → Start emulator FIRST. Then: flutter create app_name, edit pubspec, flutter pub get
5–10 min  → Write main() + MyApp + empty StatefulWidget. RUN IT.
10–25 min → Write Model class + 5 DB functions
25–45 min → Write home screen: Scaffold + ListView.builder + FAB. RUN IT.
45–65 min → Write _showForm() dialog (Add + Edit logic + validation)
65–75 min → Write _confirmDelete() dialog + SnackBars. RUN IT.
75–90 min → Test ALL 4 operations: Add → see in list → Edit → Delete. Fix bugs.
```

> 🔴 **NEVER write 80 minutes then run. Run at minute 10, 45, and 65.**

---

## 📝 THEORY EXAM — KEY CONCEPTS (2 Hours)

### Flutter Basics
- **Widget** = everything in Flutter is a widget (UI component)
- **StatelessWidget** = UI that never changes after build
- **StatefulWidget** = UI that can change (needs `setState()`)
- **`setState()`** = tells Flutter to redraw the UI with new data
- **`BuildContext`** = info about where the widget is in the widget tree

### Layout Widgets (must know)
| Widget | What it does |
|---|---|
| `Column` | Stack children top to bottom |
| `Row` | Stack children left to right |
| `Stack` | Overlap widgets on top of each other |
| `Expanded` | Take up remaining available space in Row/Column |
| `Flexible` | Like Expanded but can shrink |
| `Container` | A box with padding, margin, color, size |
| `Padding` | Adds space inside an element |
| `SizedBox` | Fixed-size box / spacer |
| `Card` | Material card with shadow |
| `ListView.builder` | Scrollable list, items built lazily |
| `GridView.builder` | Grid layout, built lazily |

### Navigation
- `Navigator.push()` → go forward to a new screen
- `Navigator.pop()` → go back to previous screen
- `MaterialPageRoute` → the animation/transition when navigating

### SQLite Key Terms
- **sqflite** = Flutter package for SQLite
- `openDatabase()` = open/create the DB file
- `onCreate` callback = runs ONCE when DB is first created (create tables here)
- `db.insert()` = INSERT INTO
- `db.query()` = SELECT *
- `db.update()` = UPDATE WHERE
- `db.delete()` = DELETE WHERE
- `toMap()` = convert Dart object to Map (to save to DB)
- `fromMap()` = convert DB row (Map) back to Dart object
- `async/await` = because DB operations take time (don't freeze the UI)
- `Future<T>` = a value that will be available in the future (like Promise in JS)

### Important Flutter Concepts for Theory
- **Hot Reload** = reloads UI while app is running, keeps state
- **Hot Restart** = full restart, resets state
- **Scaffold** = basic app layout (AppBar + body + FAB + SnackBar)
- **AppBar** = top bar of the screen
- **FloatingActionButton (FAB)** = circular button usually at bottom right
- **SnackBar** = small notification that appears at bottom
- **AlertDialog** = popup dialog box
- **TextFormField** = text input with built-in validation support
- **GlobalKey<FormState>** = controls a Form widget (used to validate)
- **`formKey.currentState!.validate()`** = runs all validators
- **`ListTile`** = ready-made list row with title, subtitle, leading, trailing

### Dart Syntax Cheat Sheet (vs Java)
| Concept | Java | Dart |
|---|---|---|
| Variable | `String name;` | `String name;` or `var name;` |
| Nullable | N/A (different) | `String? name;` (can be null) |
| Null safety | N/A | `name ?? 'default'` (if null use default) |
| Arrow function | N/A | `() => expression` |
| Named params | N/A | `Dog({required this.name})` |
| Async | `CompletableFuture` | `async/await + Future<T>` |
| Print | `System.out.println` | `print()` |
| String interp. | `"Hello " + name` | `'Hello $name'` or `'${obj.name}'` |
| List | `ArrayList<>` | `List<String> items = []` |
| Map | `HashMap<>` | `Map<String, dynamic> m = {}` |
| Factory constructor | (not same) | `factory Dog.fromMap(map) { return Dog(...); }` |

---

## 🎯 MOST LIKELY EXAM QUESTIONS (Ranked by Probability)

### 🥇 #1 — SQLite CRUD with custom entity (85% chance)
> "Create a [Book/Task/Employee/Product] Manager app with Add, View, Edit, Delete using sqflite"
**→ Use the full template above. Just rename 6 words.**

### 🥈 #2 — Fill-in-the-blank template (75% chance if they give template)
> They give you the code with `_______` blanks in:
> - `toMap()` / `fromMap()` methods
> - `initializeDB()` function
> - validator logic
> - `insertStudent()` call
> - `setState()` usage
**→ Know these by heart. See the patterns above.**

### 🥉 #3 — Navigation question (60% chance)
> "Explain / complete code for Navigator.push() to open a detail screen"
**→ Know the push/pop pattern. Know how to pass data between screens.**

### #4 — Layout question (50% chance)
> "Complete this layout using Column/Row/Stack/Expanded"
**→ Know what each widget does and their properties.**

### #5 — Short theory questions (40% chance)
> "What is setState()?" / "Difference between StatelessWidget and StatefulWidget?"
**→ See the theory section above.**

---

## 💡 LAST-MINUTE TIPS

1. **Start emulator before reading the question** — it takes 2 minutes to boot
2. **`flutter pub get` after editing pubspec.yaml** — or nothing will work
3. **sqflite ONLY works on Android emulator/device** — NOT Chrome
4. **`mainAxisSize: MainAxisSize.min`** in dialog Column — or it will overflow
5. **Call `_refreshList()` after EVERY DB write** — or list won't update
6. **`int?` for id in model** — because it's null before DB assigns it
7. **Don't try to be fancy** — working CRUD with no style beats broken styled app
8. **Test order**: Add → see in list → Edit → see change → Delete → confirm gone
