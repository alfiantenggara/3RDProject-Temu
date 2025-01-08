import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:temu_app/pages/acara_page.dart';
import 'package:temu_app/pages/addacarapage.dart';
import 'package:temu_app/dashboardperusahaan.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  late PageController pageController;
  int _selectedIndex = 0; // Untuk menentukan tab yang aktif

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottompages = const [
    PerusahaanDashboard(),
    AcaraPage(),
    AddAcaraPage(),
    Center(child: Text('Profile Screen')), // Placeholder for profile
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBottomBarTapped(int index) {
    pageController.jumpToPage(index);
  }

  Widget _bottomAppBarItem({
    required IconData defaultIcon,
    required IconData filledIcon,
    required int page,
    required String label,
  }) {
    bool isSelected = _selectedIndex == page;
    return GestureDetector(
      onTap: () => _onBottomBarTapped(page),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 7),
          Icon(
            isSelected ? filledIcon : defaultIcon,
            color: isSelected ? Colors.blue : Colors.black,
            size: 25,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.aBeeZee(
              color: isSelected ? Colors.blue : Colors.black,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Menonaktifkan swipe

        children: bottompages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        elevation: 0,
        color: Color(0xFFB9CAFF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomAppBarItem(
              defaultIcon: Icons.home_outlined,
              filledIcon: Icons.home,
              page: 0,
              label: 'Home',
            ),
            _bottomAppBarItem(
              defaultIcon: Icons.chat_bubble_outline,
              filledIcon: Icons.chat,
              page: 1,
              label: 'Chat',
            ),
            _bottomAppBarItem(
              defaultIcon: Icons.history,
              filledIcon: Icons.history,
              page: 2,
              label: 'History',
            ),
            _bottomAppBarItem(
              defaultIcon: Icons.person_outline,
              filledIcon: Icons.person,
              page: 3,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
