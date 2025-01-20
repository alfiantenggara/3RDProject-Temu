import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardperusahaan.dart';
import 'package:frontendtemu/dashboardorganisasi.dart';
import 'package:frontendtemu/profileorganisasi.dart';
import 'onboarding.dart'; 
import 'splashscreen.dart'; 
import 'loginorganisasi.dart'; 
import 'loginperusahaan.dart'; 
import 'profileperusahaan.dart'; 

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
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingPage(),
        '/loginorganisasi': (context) => const LoginOrganisasi(), 
        '/loginperusahaan': (context) => const LoginPerusahaan(), 
        '/dashboardperusahaan': (context) => DashboardPerusahaan(),
        '/dashboardorganisasi': (context) => DashboardOrganisasi(),
        '/profileperusahaan': (context) => ProfilePerusahaanPage(),
        '/profileorganisasi': (context) => ProfileOrganisasiPage(),
      },
    );
  }
}
