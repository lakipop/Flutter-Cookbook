# 📂 Templates — Ready-to-Use Dart Files

## How to use these files in VS Code:

### For SQLite CRUD Exam (most likely):
1. Open `sqlite_crud_template.dart`
2. Press `Ctrl+A` to select ALL code
3. Press `Ctrl+C` to copy
4. Go to your project's `lib/main.dart`
5. Press `Ctrl+A` then `Ctrl+V` to replace everything
6. Do the **6 renames** (Ctrl+H to Find & Replace in VS Code):
   - `Student` → your entity name
   - `students` → your table name
   - `students_database.db` → your db name
   - field names (`name, age, course`) → your fields
   - `insertStudent` → your function names
   - label texts → your labels

### For Multi-Screen UI Exam:
1. Open `multiscreen_ui_template.dart`
2. Same copy → paste into `lib/main.dart`
3. Change: app name, food items list, colors

## Files in this folder:
| File | What it is |
|---|---|
| `sqlite_crud_template.dart` | Full CRUD app with SQLite (Practical 10 pattern) |
| `multiscreen_ui_template.dart` | 3-screen UI app with Grid, Detail, Cart (Practical 07 pattern) |

## pubspec.yaml to add for SQLite template:
```
sqflite: ^2.0.0+4
path: ^1.8.0
```
