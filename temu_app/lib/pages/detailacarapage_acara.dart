import 'package:flutter/material.dart';
import 'package:temu_app/model/acara.dart';
import 'package:intl/intl.dart';

class DetailPageAcara extends StatefulWidget {
  final Acara acara;

  const DetailPageAcara({required this.acara});

  @override
  State<DetailPageAcara> createState() => DetailPageAcaraState();
}

class DetailPageAcaraState extends State<DetailPageAcara> {
  late Acara acara;

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

    int ticketCount = 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Header
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        acara.gambarAcara ??
                            'https://via.placeholder.com/600x400', // Fallback image
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Lebar sesuai ukuran ponsel
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Tanggal
                            Expanded(
                              child: Text(
                                'Tanggal: $formattedDate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14, // Ukuran lebih kecil
                                ),
                              ),
                            ),
                            // Jam
                            Expanded(
                              child: Text(
                                'Jam: $waktuMulai - $waktuSelesai',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12, // Ukuran lebih kecil untuk jam
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Lokasi
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text(
                              acara.kotaBerlangsung ?? 'Tidak tersedia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14, // Ukuran lebih kecil
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Informasi Acara
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
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
                  SizedBox(height: 8),
                  Text(
                    'Lokasi: ${acara.lokasiAcara ?? 'Tidak tersedia'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of Tickets',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (ticketCount > 1) {
                                setState(() {
                                  ticketCount--;
                                });
                              }
                            },
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$ticketCount',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ticketCount++;
                              });
                            },
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount: \$${acara.biayaDibutuhkan}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika pemesanan tiket di sini
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: Colors.purple,
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
