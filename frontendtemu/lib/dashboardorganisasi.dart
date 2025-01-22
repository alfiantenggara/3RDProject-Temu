import 'package:flutter/material.dart';
import 'package:frontendtemu/loginorganisasi.dart';
import 'package:frontendtemu/profileorganisasi.dart';
import 'package:frontendtemu/service/auth_service.dart';
import 'package:frontendtemu/service/perusahaan_service.dart'; // Import service perusahaan

class DashboardOrganisasi extends StatefulWidget {
  @override
  _DashboardOrganisasiState createState() => _DashboardOrganisasiState();
}

class _DashboardOrganisasiState extends State<DashboardOrganisasi> {
  TextEditingController searchController = TextEditingController();
  String keywordSearch = ''; // Variable buat nyimpen keyword search
  late Future<Map<dynamic, dynamic>>
      perusahaanList; // Kita bikin list perusahaan sebagai Future

  @override
  void initState() {
    super.initState();
    // Initial load perusahaan
    perusahaanList = PerusahaanService().getAllPerusahaan(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getUserData(context),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFFDED0CE),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Color(0xFFDED0CE),
            body: Center(
                child: Text('Error loading data: ${userSnapshot.error}')),
          );
        } else {
          final userData = userSnapshot.data as Map<dynamic, dynamic>?;
          if (userData == null || userData['success'] == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginOrganisasi()),
                (route) => false,
              );
            });
            return SizedBox();
          }

          final String namaOrganisasi =
              userData['data']['namaOrganisasi'] ?? 'Organisasi';

          return Scaffold(
            backgroundColor: Color(0xFFDED0CE),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Dashboard Organisasi',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: FutureBuilder(
              future: perusahaanList,
              builder: (context, perusahaanSnapshot) {
                if (perusahaanSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (perusahaanSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error loading perusahaan: ${perusahaanSnapshot.error}'));
                } else {
                  final resultPerusahaan =
                      perusahaanSnapshot.data as Map<dynamic, dynamic>;
                  final perusahaanListData = resultPerusahaan['data'] ?? [];
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
                                  'Perusahaan Tersedia',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Hi, $namaOrganisasi!\nYuk kita lihat perusahaan mana yang cocok buat kamu!",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: searchController,
                                  onSubmitted: (value) {
                                    // Ketika Enter ditekan
                                    _searchPerusahaan(value);
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
                            title: perusahaanListData.isNotEmpty
                                ? 'Perusahaan Tersedia'
                                : 'Tidak Ada Perusahaan',
                            items: perusahaanListData
                                .map<PerusahaanCard>((perusahaan) {
                              return PerusahaanCard(
                                name: perusahaan['namaperusahaan'] ??
                                    'Nama Perusahaan Tidak Diketahui',
                                location:
                                    perusahaan['kotadomisiliperusahaan'] ??
                                        'Kota Tidak Diketahui',
                                phone: perusahaan['nomorteleponperusahaan'] ??
                                    'Telepon Tidak Diketahui',
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
                  case 3:
                    // Navigasi ke ProfileOrganisasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileOrganisasiPage()),
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

  // Fungsi untuk search perusahaan
  Future<void> _searchPerusahaan(String keyword) async {
    setState(() {
      if (keyword.isEmpty) {
        // Kalau keyword kosong, panggil getAllPerusahaan()
        perusahaanList = PerusahaanService().getAllPerusahaan(context);
      } else {
        // Kalau ada keyword, panggil searchPerusahaan()
        perusahaanList = PerusahaanService().searchPerusahaan(keyword, context);
      }
    });
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<PerusahaanCard> items;

  const Section({required this.title, required this.items});

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
        // Gunakan ListView dengan tinggi yang responsif
        Container(
          height: 190, // Tetap batasi tinggi
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
          ),
        ),
      ],
    );
  }
}

class PerusahaanCard extends StatelessWidget {
  final String name;
  final String location;
  final String phone;

  const PerusahaanCard({
    required this.name,
    required this.location,
    required this.phone,
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
      clipBehavior: Clip.hardEdge, // Tambahkan ini
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon dengan ukuran yang lebih kecil
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Icon(
              Icons.person,
              size: 80, // Ukuran ikon dikurangi
              color: Colors.grey[600],
            ),
          ),
          // Gunakan Expanded untuk teks agar tidak overflow
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Pastikan Column tidak mengambil ruang lebih
                children: [
                  // Nama Perusahaan
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Lokasi Perusahaan
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Nomor Telepon
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}