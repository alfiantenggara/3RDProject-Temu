import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _hoveredButton;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Selamat Datang di Aplikasi TEMU",
      "description": "Ayo bersama membuat dampak yang lebih baik.",
      "image": "assets/TEMU.png",
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
                itemCount: onboardingData.length + 1,
                itemBuilder: (context, index) {
                  if (index < onboardingData.length) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (data.containsKey('image'))
                            Image.asset(data['image']!, height: 300)
                          else if (data.containsKey('animation'))
                            SizedBox(
                              height: 300,
                              child: Lottie.asset(data['animation']!),
                            ),
                          const SizedBox(height: 24),
                          Text(
                            data['title']!,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data['description']!,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 130),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCustomButton(
                                text: "Lewati",
                                defaultColor: const Color(0xFF515D84),
                                hoverColor: const Color(0xFF737BA1),
                                onPressed: () {
                                  _pageController.jumpToPage(onboardingData.length);
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildCustomButton(
                                text: "Lanjut",
                                defaultColor: const Color(0xFF3B6BFD),
                                hoverColor: const Color(0xFF5B86FF),
                                onPressed: () {
                                  if (_currentPage == onboardingData.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _buildFinalPage(context);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onboardingData.length + 1,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey.shade400,
                  activeDotColor: const Color(0xFF3B6BFD),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 4,
                  spacing: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/TEMU.png', height: 200),
          const SizedBox(height: 24),
          Text(
            "Masuk Sebagai",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildSelectionButton(
            text: "Organisasi",
            onPressed: () {
              print("Navigasi ke halaman Organisasi");
            },
          ),
          const SizedBox(height: 20),
          _buildSelectionButton(
            text: "Perusahaan",
            onPressed: () {
              print("Navigasi ke halaman Perusahaan");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    bool isHovered = _hoveredButton == text;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredButton = text;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredButton = null;
        });
      },
      child: SizedBox(
        width: 200, // Ukuran tetap untuk lebar tombol
        height: 60, // Ukuran tetap untuk tinggi tombol
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovered ? const Color(0xFF5B86FF) : const Color(0xFF3B6BFD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required Color defaultColor,
    required Color hoverColor,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredButton = text;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredButton = null;
        });
      },
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: _hoveredButton == text ? hoverColor : defaultColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
