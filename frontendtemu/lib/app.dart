import 'package:flutter/material.dart';
import 'onboarding.dart'; // File untuk Onboarding
import 'splashscreen.dart'; // File untuk Splashscreen
// import 'loginorganisasi.dart'; // File untuk halaman Organisasi
// import 'loginperusahaan.dart'; // File untuk halaman Perusahaan

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
        '/': (context) => OnboardingPage(), // Rute awal (Onboarding)
        '/splash': (context) => SplashScreen(), // Splashscreen
        // '/organisasi': (context) => OrganisasiScreen(), // Halaman Organisasi
        // '/perusahaan': (context) => PerusahaanScreen(), // Halaman Perusahaan
      },
    );
  }
}
