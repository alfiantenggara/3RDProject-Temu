import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temu_app/model/acara.dart'; // Sesuaikan dengan path model yang benar

// Fungsi untuk mengambil data acara
Future<List<Acara>> fetchAcara() async {
  final response = await http.get(Uri.parse('https://api.example.com/acara'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Acara.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load acara');
  }
}

Future<List<Acara>> fetchAcaraByTanggal(DateTime targetDate) async {
  List<Acara> acaraList = await fetchAcara();
  return acaraList.where((acara) {
    return acara.tanggalAcara?.year == targetDate.year &&
        acara.tanggalAcara?.month == targetDate.month &&
        acara.tanggalAcara?.day == targetDate.day;
  }).toList();
}

Future<List<Acara>> fetchAcaraByKota(String kota) async {
  List<Acara> acaraList = await fetchAcara();
  return acaraList.where((acara) => acara.kotaBerlangsung == kota).toList();
}

class Horizontallist extends StatelessWidget {
  final DateTime targetDate = DateTime.now();
// Filter acara pada tanggal tertentu
  final String targetKota = ""; // Filter acara yang diadakan di Jakarta
  Horizontallist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acara List')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Acara pada ${targetDate.toLocal()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          FutureBuilder<List<Acara>>(
            future: fetchAcaraByTanggal(targetDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Tidak ada acara pada tanggal ini.'));
              } else {
                final acaraList = snapshot.data!;
                return Container(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: acaraList.length,
                    itemBuilder: (context, index) {
                      final acara = acaraList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  acara.gambarAcara?.isNotEmpty == true
                                      ? acara.gambarAcara!
                                      : '',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/logo.png',
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )),
                            const SizedBox(height: 8),
                            Text(
                              acara.namaAcara ?? 'Nama Acara Tidak Tersedia',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              acara.lokasiAcara ?? 'Biaya Tidak Tersedia',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
