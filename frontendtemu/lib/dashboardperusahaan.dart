import 'package:flutter/material.dart';
import 'package:frontendtemu/loginperusahaan.dart';
import 'package:frontendtemu/profileperusahaan.dart';
import 'package:frontendtemu/service/auth_service.dart';
import 'package:frontendtemu/service/acara_service.dart';
import 'dart:convert';

class DashboardPerusahaan extends StatefulWidget {
  @override
  _DashboardPerusahaanState createState() => _DashboardPerusahaanState();
}

class _DashboardPerusahaanState extends State<DashboardPerusahaan> {
  TextEditingController searchController = TextEditingController();
  String keywordSearch = ''; // Variable buat nyimpen keyword search
  late Future<Map<dynamic, dynamic>>
      acaraList; // Kita bikin list acara sebagai Future

  @override
  void initState() {
    super.initState();
    // Initial load acara
    acaraList = AcaraService().getAllAcara(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getUserData(context),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFFECE5E4),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Color(0xFFECE5E4),
            body: Center(
                child: Text('Error loading data: ${userSnapshot.error}')),
          );
        } else {
          final userData = userSnapshot.data as Map<dynamic, dynamic>?;
          if (userData == null || userData['success'] == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPerusahaan()),
                (route) => false,
              );
            });
            return SizedBox();
          }

          final String namaPerusahaan =
              userData['data']['namaPerusahaan'] ?? 'Perusahaan';

          return Scaffold(
            backgroundColor: Color(0xFFECE5E4),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Dashboard Perusahaan',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: FutureBuilder(
              future: acaraList,
              builder: (context, acaraSnapshot) {
                if (acaraSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (acaraSnapshot.hasError) {
                  return Center(
                      child:
                          Text('Error loading acara: ${acaraSnapshot.error}'));
                } else {
                  final resultAcara =
                      acaraSnapshot.data as Map<dynamic, dynamic>;
                  final acaraListData = resultAcara['data'] ?? [];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Event Tersedia',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Hi, $namaPerusahaan!\nYuk kita lihat event mana yang cocok buat kamu!",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: searchController,
                                  onSubmitted: (value) {
                                    // Ketika Enter ditekan
                                    _searchAcara(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Cari',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Section(
                            title: acaraListData.isNotEmpty
                                ? 'Events Available'
                                : 'No Events',
                            events: acaraListData.map<EventCard>((acara) {
                              return EventCard(
                                title: acara['nama_acara'] ??
                                    'Acara Tidak Diketahui',
                                price: acara['biaya_dibutuhkan'] != null
                                    ? 'Rp. ${acara['biaya_dibutuhkan']}'
                                    : 'Rp. 0',
                                imageAsset: Image.memory(
                                  base64Decode(acara['poster_acara']),
                                  height: 80,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Pesan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              onTap: (index) {
                // Handle item tap
                switch (index) {
                  case 0:
                    // Home Page logic
                    break;
                  case 1:
                    // Pesan logic
                    break;
                  case 2:
                    // Navigasi ke ProfilePerusahaan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePerusahaanPage()),
                    );
                    break;
                }
              },
            ),
          );
        }
      },
    );
  }

  // Fungsi untuk search acara
  Future<void> _searchAcara(String keyword) async {
    setState(() {
      if (keyword.isEmpty) {
        // Kalau keyword kosong, panggil getAllAcara()
        acaraList = AcaraService().getAllAcara(context);
      } else {
        // Kalau ada keyword, panggil searchAcara()
        acaraList = AcaraService().searchAcara(keyword, context);
      }
    });
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<EventCard> events;

  const Section({required this.title, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return events[index];
            },
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String price;
  final Image imageAsset;

  const EventCard({
    required this.title,
    required this.price,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: imageAsset,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
