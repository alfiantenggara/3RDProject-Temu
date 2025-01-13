import 'package:flutter/material.dart';
import 'package:temu_app/model/acara.dart';
import 'package:intl/intl.dart';

class DetailPageAcara extends StatefulWidget {
  final Acara acara;

  const DetailPageAcara({Key? key, required this.acara}) : super(key: key);

  @override
  State<DetailPageAcara> createState() => DetailPageAcaraState();
}

class DetailPageAcaraState extends State<DetailPageAcara> {
  late Acara acara;
  int ticketCount = 1;

  @override
  void initState() {
    super.initState();
    acara = widget.acara;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = acara.tanggalAcara != null
        ? DateFormat('dd MMM yyyy').format(acara.tanggalAcara!)
        : 'Tanggal tidak tersedia';

    String waktuMulai = acara.detailWaktu?.isNotEmpty == true
        ? acara.detailWaktu![0].formatWaktu(acara.detailWaktu![0].waktuMulai)
        : 'Tidak tersedia';

    String waktuSelesai = acara.detailWaktu?.isNotEmpty == true
        ? acara.detailWaktu![0].formatWaktu(acara.detailWaktu![0].waktuSelesai)
        : 'Tidak tersedia';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image and flexible space
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: acara.gambarAcara ??
                            'https://via.placeholder.com/600x400',
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            acara.gambarAcara ??
                                'https://via.placeholder.com/600x400',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SliverFillRemaining to push the content to the top and leave space for the button
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius:
                      BorderRadius.circular(16), // Circular border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Blur radius for the shadow
                      offset: Offset(0, 4), // Position of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acara.namaAcara ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            acara.kotaBerlangsung ?? 'Lokasi tidak tersedia',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jam: $waktuMulai - $waktuSelesai',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tentang Acara',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deskripsi tidak tersedia.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Lokasi Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        acara.lokasiAcara ?? 'Lokasi tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom button fixed at the bottom of the screen
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Add logic for ticket booking
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Adjust border radius
            ),
          ),
          child: const Text(
            'Pesan Sekarang',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
