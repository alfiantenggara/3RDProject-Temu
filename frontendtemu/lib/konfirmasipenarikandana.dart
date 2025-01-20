import 'package:flutter/material.dart';

class TransactionConfirmationScreen extends StatelessWidget {
  final bool isSuccess;

  const TransactionConfirmationScreen({
    Key? key,
    this.isSuccess = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Penerimaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isSuccess)
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
            const SizedBox(height: 24),
            const Text(
              'Rp 1.050.000',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            TransactionDetailItem(
              label: 'Rekening Tujuan',
              value: 'CIMB Mega',
              isDropdown: !isSuccess,
            ),
            TransactionDetailItem(
              label: 'Nomor Rekening',
              value: 'C1446418355',
            ),
            TransactionDetailItem(
              label: 'Periode Rekening',
              value: 'YKAN',
            ),
            const Divider(height: 32),
            TransactionDetailItem(
              label: 'Total Biaya Admin',
              value: 'Rp 400.000',
            ),
            TransactionDetailItem(
              label: 'Total',
              value: 'Rp 400.000',
              isBold: true,
            ),
            const Spacer(),
            if (!isSuccess) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to success screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TransactionConfirmationScreen(
                          isSuccess: true,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Tarik Dana',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // Handle chat support
                },
                icon: const Icon(Icons.headset_mic),
                label: const Text('Masalah Terkait Penarikan'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle download receipt
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Bukti Penerimaan'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Kembali ke Halaman Utama',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class TransactionDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDropdown;
  final bool isBold;

  const TransactionDetailItem({
    Key? key,
    required this.label,
    required this.value,
    this.isDropdown = false,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isDropdown)
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
