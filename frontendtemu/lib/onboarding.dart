import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Selamat Datang di Aplikasi TEMU",
      "description": "Ayo bersama membuat dampak yang lebih baik.",
      "image": "assets/TEMU.png", // Tambahkan referensi gambar
    },
    {
      "title": "Bantu Organisasi Lingkungan Menjalankan Programnya",
      "description": "Kontribusikan ide dan tenaga Anda.",
      "animation": "assets/GAMBAR2.json",
    },
    {
      "title": "Temukan Sponsor Untuk Acara Lingkungan",
      "description": "Hubungkan acara dengan sponsor yang mendukung.",
      "animation": "assets/GAMBAR3.json",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFC1C5D0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (data.containsKey('image')) ...[
                        Image.asset(data['image']!, height: 300),
                      ] else if (data.containsKey('animation')) ...[
                        SizedBox(
                          height: 300,
                          child: Lottie.asset(data['animation']!),
                        ),
                      ],
                      Text(
                        data['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['description']!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(onboardingData.length - 1);
                  },
                  child: const Text("Lewati"),
                ),
                Row(
                  children: List.generate(
                    onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.blue
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      print("Navigasi ke halaman utama");
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Text("Lanjut"),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
