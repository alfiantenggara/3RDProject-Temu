import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardorganisasi.dart';
import 'package:frontendtemu/profileorganisasi.dart';
import 'onboarding.dart'; // File untuk Onboarding
import 'splashscreen.dart'; // File untuk Splashscreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEMU App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Rute awal menuju SplashScreen
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingPage(),
        '/dashboardorganisasi': (context) => DashboardOrganisasi(),
        '/profileperusahaan': (context) => const ProfilePerusahaanPage(),
        '/profileorganisasi': (context) => ProfileOrganisasiPage(),
      },
    );
  }
}
