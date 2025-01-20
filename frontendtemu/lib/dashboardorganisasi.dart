import 'package:flutter/material.dart';

theme() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardOrganisasi(),
  );
}

class DashboardOrganisasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDED0CE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Dashboard Organisasi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Perusahaan Tersedia",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Hi, KEHATI!",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Yuk lihat Perusahaan mana yang paling cocok dengan konsep acara Kamu!",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Cari",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              SectionWidget(
                title: "Sponsor Top 100 Bulan Ini",
                items: [
                  SponsorItem(name: "Astra", description: "PT Astra Internasional Tbk", events: "500 Event"),
                  SponsorItem(name: "BRI", description: "PT Bank Rakyat Indonesia (Persero) Tbk", events: "350 Event"),
                  SponsorItem(name: "Telkom", description: "PT Telkom Indonesia (Persero) Tbk", events: "200 Event"),
                ],
              ),
              SectionWidget(
                title: "Perusahaan di Sekitarmu",
                items: [
                  SponsorItem(name: "Astra", description: "PT Astra Internasional Tbk", events: "500 Event"),
                  SponsorItem(name: "BRI", description: "PT Bank Rakyat Indonesia (Persero) Tbk", events: "350 Event"),
                  SponsorItem(name: "Telkom", description: "PT Telkom Indonesia (Persero) Tbk", events: "200 Event"),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Pesan"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<SponsorItem> items;

  SectionWidget({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Lebih Lanjut",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ItemCard(item: item),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SponsorItem {
  final String name;
  final String description;
  final String events;

  SponsorItem({required this.name, required this.description, required this.events});
}

class ItemCard extends StatelessWidget {
  final SponsorItem item;

  ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/GAMBAR4.png", height: 100.0, width: double.infinity, fit: BoxFit.cover),
          SizedBox(height: 8.0),
          Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            item.events,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
