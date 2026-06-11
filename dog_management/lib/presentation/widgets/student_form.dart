import 'package:flutter/material.dart';
import '../../domain/models/student.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final Function(Student) onSubmit;

  const StudentForm({super.key, this.student, required this.onSubmit});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _courseController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _ageController = TextEditingController(text: widget.student?.age.toString() ?? '');
    _courseController = TextEditingController(text: widget.student?.course ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || int.tryParse(value) == null) ? 'Please enter a valid age' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _courseController,
            decoration: const InputDecoration(
              labelText: 'Course',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.book),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a course' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final student = Student(
                  id: widget.student?.id,
                  name: _nameController.text,
                  age: int.parse(_ageController.text),
                  course: _courseController.text,
                );
                widget.onSubmit(student);
              }
            },
            child: Text(widget.student == null ? 'Add Student' : 'Update Student'),
          ),
        ],
      ),
    );
  }
}
