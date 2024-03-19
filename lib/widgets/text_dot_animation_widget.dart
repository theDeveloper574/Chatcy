import 'package:flutter/material.dart';

class DotDotDotAnimation extends StatefulWidget {
  const DotDotDotAnimation({super.key});

  @override
  _DotDotDotAnimationState createState() => _DotDotDotAnimationState();
}

class _DotDotDotAnimationState extends State<DotDotDotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Adjust duration as needed
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the number of dots based on the animation value
        int numDots = (_controller.value * 3).floor() + 1;
        // Generate the "dot dot dot" text with the appropriate number of dots
        String dots = '.' * numDots;
        return Text(
          'Typing$dots',
          style: const TextStyle(fontSize: 16), // Adjust font size as needed
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
