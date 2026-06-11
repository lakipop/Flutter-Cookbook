# System Architecture - Student Manager (SQLite)

## Overview
A high-performance Flutter application for managing student records using a local SQLite database.

## Tech Stack
- **Framework**: Flutter (Dart)
- **Local Storage**: SQLite (`sqflite`)
- **Architecture**: Clean Architecture / DDD Lite

## Layered Folder Structure
- `lib/domain/models`: Data entities (`student.dart`).
- `lib/data/local`: Database initialization and CRUD operations (`database_service.dart`).
- `lib/presentation/screens`: UI screens (`student_list_screen.dart`).
- `lib/presentation/widgets`: Reusable UI components (`student_form.dart`).
- `lib/main.dart`: Entry point and global theme configuration.
