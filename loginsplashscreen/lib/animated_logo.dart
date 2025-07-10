import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui' as ui;
class AnimatedGrievEaseLogo extends StatefulWidget {
  @override
  _AnimatedGrievEaseLogoState createState() => _AnimatedGrievEaseLogoState();
}

class _AnimatedGrievEaseLogoState extends State<AnimatedGrievEaseLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/Grievance.json', // Correct path!
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
              _controller.repeat();
            },
            height: 300, // Adjust as needed
          ),

        ],
      ),
    );
  }
}