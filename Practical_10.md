# ICT4153 Mobile Application Development
## Practical 10
### Flutter – Database concepts

**Dept of ICT, Faculty of Technology, University of Ruhuna**
**206**

---

## Objective

To provide a comprehensive, hands-on guide for integrating SQLite databases into Flutter applications using the sqflite package.

---

## Introduction to SQLite in Flutter

SQLite is a lightweight, relational database management system that operates directly on a device's file system. In Flutter, the sqflite package serves as a bridge to interact with SQLite databases, allowing developers to perform standard database operations such as create, read, update, and delete (CRUD).

---

## Setting Up sqflite in Flutter

To integrate SQLite into your Flutter project, follow these steps:

**1. Add Dependencies:** Include sqflite and path packages in your pubspec.yaml file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4
  path: ^1.8.0
```

**2. Import Packages:** In your Dart file, import the necessary packages:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
```

---

## Implementing CRUD Operations

Let's walk through the process of creating a simple application to manage a list of dogs, demonstrating CRUD operations.

### Define the Data Model

Create a Dog class to represent the data:

```dart
class Dog {
  final int? id;
  final String name;
  final int age;

  Dog({this.id, required this.name, required this.age});

  // Convert a Dog into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Extract a Dog object from a Map.
  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }
}
```

### Open the Database

Initialize and open the database, creating the necessary table if it doesn't exist:

```dart
Future<Database> initializeDB() async {
  String path = join(await getDatabasesPath(), 'dogs_database.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
      );
    },
    version: 1,
  );
}
```

### Insert Data

To insert a new dog into the database:

```dart
Future<void> insertDog(Dog dog) async {
  final db = await initializeDB();
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

### Retrieve Data

To retrieve all dogs from the database:

```dart
Future<List<Dog>> retrieveDogs() async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.query('dogs');
  return queryResult.map((e) => Dog.fromMap(e)).toList();
}
```

### Update Data

To update an existing dog's information:

```dart
Future<void> updateDog(Dog dog) async {
  final db = await initializeDB();
  await db.update(
    'dogs',
    dog.toMap(),
    where: 'id = ?',
    whereArgs: [dog.id],
  );
}
```

### Delete Data

To delete a dog from the database:

```dart
Future<void> deleteDog(int id) async {
  final db = await initializeDB();
  await db.delete(
    'dogs',
    where: 'id = ?',
    whereArgs: [id],
  );
}
```

---

## Best Practices

- **Error Handling:** Implement try-catch blocks around database operations to manage exceptions gracefully.
- **Asynchronous Operations:** Utilize asynchronous programming (async/await) to prevent blocking the main thread during database operations.
- **Resource Management:** Ensure that database connections are properly closed when no longer needed to free up system resources.

---

## Activity

Apply your understanding of Flutter and SQLite (sqflite package) to develop a mobile application that performs CRUD operations on student data stored locally.

### App Description

Create a Student Manager App that allows users to:

- Add new student records (Name, Age, Course)
- View a list of all students
- Edit an existing student's details
- Delete a student record

### Core Requirements

**1. Database Integration**
- Use the sqflite package for SQLite integration.
- Create a students table with fields: id, name, age, course.

**2. UI Functionality**
- Form to input new student details.
- List view to display all students with Edit and Delete buttons.
- Update form pre-filled with existing data.
- Confirmation dialog before deleting.

**3. CRUD Operations**
- **Create:** Insert new student data into the database.
- **Read:** Fetch and display all students from the database.
- **Update:** Modify selected student details.
- **Delete:** Remove a student record.

**4. User Experience**
- Use proper input validation (e.g., no empty fields).
- Show Snackbar or Toast for actions like "Student Added", "Deleted", etc.

---

## Optional Enhancements

- Add a search feature by student name.
- Use a dropdown for selecting a course.
- Add icons and styling for a polished UI.
- Implement sorting by name or age.

---

## Submission Requirements

- Submit the complete Flutter project to the given link in LMS.
