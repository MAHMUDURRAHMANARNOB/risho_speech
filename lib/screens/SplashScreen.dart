import 'package:flutter/material.dart';
import 'package:risho_speech/screens/WelcomeScreen.dart';

import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Simulate some initialization tasks (e.g., data loading) here.
    // After completing the tasks, navigate to the next screen.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 1000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/risho_guru_icon.png', // Replace with the path to your logo image
                  width: 400.0, // Set the desired width
                  height: 200.0,
                ), // Replace with your app's logo
              ],
            ),
          ),
        ),
      ),
    );
  }
}
