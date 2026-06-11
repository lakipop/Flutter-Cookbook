# Student Manager — Exam Practice App

A Flutter + SQLite CRUD app built as exam practice for ICT4153.

## Features
- Add new student records (Name, Age, Course)
- View all students in a scrollable list
- Edit existing student via pre-filled dialog
- Delete student with confirmation dialog
- SnackBar feedback for all operations
- Input validation on all fields

## Tech Stack
- Flutter (Dart)
- sqflite (SQLite)
- StatefulWidget + setState

## Run
```bash
flutter pub get
flutter run   # Android emulator required for sqflite
```

## Key Patterns
- Model: toMap() / fromMap() for DB serialization
- DB: initializeDB() with openDatabase()
- Form: GlobalKey<FormState> + TextFormField validators
- State: _refreshList() called after every CRUD operation
