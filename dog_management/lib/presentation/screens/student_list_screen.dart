import 'package:flutter/material.dart';
import '../../data/local/database_service.dart';
import '../../domain/models/student.dart';
import '../widgets/student_form.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  void _refreshStudents() {
    setState(() {
      _studentsFuture = _dbService.retrieveStudents();
    });
  }

  void _showForm([Student? student]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: StudentForm(
          student: student,
          onSubmit: (newStudent) async {
            if (student == null) {
              await _dbService.insertStudent(newStudent);
              _showSnackBar('Student Added Successfully');
            } else {
              await _dbService.updateStudent(newStudent);
              _showSnackBar('Student Updated Successfully');
            }
            Navigator.pop(context);
            _refreshStudents();
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _deleteStudent(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this student record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbService.deleteStudent(id);
      _showSnackBar('Student Deleted');
      _refreshStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No students found. Add one to get started!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final students = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber[700],
                    child: Text(student.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${student.course} • Age: ${student.age}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(student)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteStudent(student.id!)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
