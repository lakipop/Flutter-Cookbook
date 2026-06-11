import 'package:flutter/material.dart';
import 'animated_logo.dart';
import 'rotating_container.dart';
import 'bouncing_container.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const AnimatedStartupPage(),
    );
  }
}

class AnimatedStartupPage extends StatefulWidget {
  const AnimatedStartupPage({super.key});

  @override
  State<AnimatedStartupPage> createState() => _AnimatedStartupPageState();
}

class _AnimatedStartupPageState extends State<AnimatedStartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Startup App'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLogo(),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RotatingContainer(),
                BouncingContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
