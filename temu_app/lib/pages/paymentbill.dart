import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temu_app/model/bayar.dart'; // Import intl package

class PaymentBillPage extends StatelessWidget {
  final DetailPembayaran detailPembayaran;

  const PaymentBillPage({super.key, required this.detailPembayaran});

  @override
  Widget build(BuildContext context) {
    var currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Format tanggal
    var dateFormatter = DateFormat('dd MMM yyyy');
    String formattedDate = dateFormatter
        .format(detailPembayaran.tanggalPembayaran ?? DateTime.now());

    int totalBiaya = (detailPembayaran.biayaSponsor ?? 0) +
        (detailPembayaran.biayaLayanan ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              'ID Pembayaran: ${detailPembayaran.idPembayaran}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'ID Rekening Temu: ${detailPembayaran.idRekeningTemu}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Biaya Sponsor: ${currencyFormatter.format(detailPembayaran.biayaSponsor)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Biaya Layanan: ${currencyFormatter.format(detailPembayaran.biayaLayanan)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Biaya: ${currencyFormatter.format(totalBiaya)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Tanggal Pembayaran: $formattedDate',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk memproses pembayaran lebih lanjut
              },
              child: const Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
