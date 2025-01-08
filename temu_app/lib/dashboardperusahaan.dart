import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'searchscreen.dart';

class PerusahaanDashboard extends StatelessWidget {
  const PerusahaanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0, // Menghilangkan bayangan
        toolbarHeight: height * 0.1, // Tinggi AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/image/logo.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "TEMU",
                  style: GoogleFonts.audiowide(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.person_2_outlined, // Ikon orang
                color: Colors.black, // Warna ikon
                size: 30, // Ukuran ikon
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Konten langsung dimulai tanpa header yang terpisah
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, Astra Group",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Yuk, kita lihat event mana yang cocok buat kamu!",
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Bagian Konten
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        child: Text(
                          'Berita Terbaru',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSwipeSlider(
                        itemCount: 5,
                        viewportFraction: 1.0,
                        cardBuilder: (index) => _buildCarouselCard(
                          index: index,
                          context: context,
                          title: 'Berita',
                          description: 'Deskripsi singkat untuk berita $index.',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Rekomendasi Event',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Event Desember'),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SearchPage()),
                                );
                              },
                              child: Text(
                                'Lebih Lanjut',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildHorizontalList(
                          context: context,
                          itemCount: 10,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Event Makassar'),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SearchPage()),
                                );
                              },
                              child: Text(
                                'Lebih Lanjut',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildHorizontalList(
                          context: context,
                          itemCount: 10,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

/// Widget Swipe Slider
Widget _buildSwipeSlider({
  required int itemCount,
  required double viewportFraction,
  required Widget Function(int index) cardBuilder,
}) {
  return SizedBox(
    height: 200,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 2.0), // Menambahkan padding horizontal
      child: PageView.builder(
        controller:
            PageController(viewportFraction: viewportFraction, initialPage: 0),
        scrollDirection: Axis.horizontal, // Mengatur scroll horizontal

        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Transform.scale(
            scale: 0.8, // Memberikan efek skala pada item fokus
            child: cardBuilder(index),
          );
        },
      ),
    ),
  );
}

Widget _buildHorizontalList({
  required BuildContext context,
  required int itemCount,
}) {
  return SizedBox(
    height: 200, // Tinggi keseluruhan horizontal list
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10), // Jarak antar item
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(
                    eventName: "Rekomendasi Event $index",
                  ),
                ),
              );
            },
            child: Container(
              width: 150, // Lebar tiap item
              decoration: BoxDecoration(
                color: Colors.white, // Warna box biru transparan
                borderRadius: BorderRadius.circular(10), // Sudut melengkung
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 5), // Shadow bawah
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      "assets/image/logo.png",
                      height: 100, // Tinggi gambar
                      width: 150, // Lebar gambar sesuai container
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 8.0), // Jarak antara gambar dan kontainer
                  // Container di bawah gambar
                  Container(
                    width: 150, // Lebar Container sama dengan gambar
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melengkung
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Margin dalam container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul
                        Text(
                          "Event $index",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Warna teks
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        // Harga
                        Text(
                          "Rp ${100000 + (index * 5000)}",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.green, // Warna harga
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildCarouselCard({
  required int index,
  required String title,
  required String description,
  required Color color,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailScreen(eventName: "$title $index"),
        ),
      );
    },
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withOpacity(0.7),
                ),
                child: Center(
                  child: Text(
                    "$title $index",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

class EventDetailScreen extends StatelessWidget {
  final String eventName;

  const EventDetailScreen({required this.eventName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      body: Center(
        child: Text(
          'Detail untuk $eventName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Halaman Chat
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chat Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Inbox
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Inbox Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Profile
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
