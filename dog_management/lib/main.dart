import 'package:flutter/material.dart';
import 'presentation/screens/student_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2C2C2C),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const StudentListScreen(),
    );
  }
}
