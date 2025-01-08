import 'package:flutter/material.dart';
import 'package:temu_app/model/acara.dart';

class DetailAcaraPage extends StatelessWidget {
  final Acara acara;

  const DetailAcaraPage({Key? key, required this.acara}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(acara.namaAcara ?? 'Detail Acara'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (acara.gambarAcara != null)
              Center(
                child: Image.network(
                  acara.gambarAcara!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 100);
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              acara.namaAcara ?? 'Nama tidak tersedia',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokasi: ${acara.lokasiAcara ?? 'Tidak tersedia'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Biaya: Rp ${acara.biayaDibutuhkan ?? 'Tidak diketahui'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Kota Berlangsung: ${acara.kotaBerlangsung ?? 'Tidak tersedia'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Waktu Acara:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (acara.detailWaktu != null && acara.detailWaktu!.isNotEmpty)
              ...acara.detailWaktu!.map(
                (detail) => Text(
                  '${detail.formatWaktu(detail.waktuMulai)} - ${detail.formatWaktu(detail.waktuSelesai)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            if (acara.detailWaktu == null || acara.detailWaktu!.isEmpty)
              const Text('Detail waktu tidak tersedia'),
          ],
        ),
      ),
    );
  }
}
