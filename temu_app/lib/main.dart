import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:temu_app/bottombar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor:
          Colors.transparent, // Transparent background for custom container
      onInit: () {
        debugPrint("On Init"); // Called when the splash screen starts
      },
      onEnd: () {
        debugPrint("On End"); // Called when the splash screen ends
      },
      childWidget: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 121, 227, 249),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Image.asset("assets/image/logo.png"), // Your splash image
          ),
        ),
      ),
      duration: const Duration(seconds: 3), // Duration of the fade-in effect
      animationDuration: const Duration(seconds: 1), // Animation duration
      onAnimationEnd: () {
        debugPrint("On Fade In End");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavigationMenu()),
        );
      },
    );
  }
}
