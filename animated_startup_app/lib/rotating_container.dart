import 'package:flutter/material.dart';

class RotatingContainer extends StatefulWidget {
  const RotatingContainer({super.key});

  @override
  State<RotatingContainer> createState() => _RotatingContainerState();
}

class _RotatingContainerState extends State<RotatingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Spin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
