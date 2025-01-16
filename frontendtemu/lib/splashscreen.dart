import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FC3F7),
              Color(0xFF4C81B7),
              Color(0xFF4171B9),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/TEMU.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
