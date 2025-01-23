import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardorganisasi.dart';
import 'package:frontendtemu/profileorganisasi.dart';
import 'package:frontendtemu/chatOrganisasi/chat.dart'; // Import halaman list pesan
import 'package:frontendtemu/loginorganisasi.dart';
import 'package:frontendtemu/service/auth_service.dart';

class PenarikanPage extends StatefulWidget {
  const PenarikanPage({Key? key}) : super(key: key);

  @override
  State<PenarikanPage> createState() => _PenarikanPageState();
}

class _PenarikanPageState extends State<PenarikanPage> {
  bool isSuccess = false;
  final TextEditingController _jumlahController = TextEditingController();
  final List<String> _bankList = [
    'Bank BCA',
    'Bank Mandiri',
    'Bank BRI',
    'Bank BNI',
    'Bank CIMB Niaga',
  ];
  String? _selectedBank = 'Bank BCA';
  int _selectedIndex = 2; // Set indeks ke-2 sebagai default

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2; // Pastikan indeks ke-2 aktif saat inisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getUserData(context),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
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

          return Scaffold(
            appBar: AppBar(
              title: const Text('Penarikan'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isSuccess ? _buildSuccessScreen(context) : _buildFormScreen(context),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex, // Set indeks yang aktif
              onTap: (index) {
                setState(() {
                  _selectedIndex = index; // Update indeks yang aktif
                });
                // Handle item tap
                switch (index) {
                  case 0:
                    // Navigasi ke Beranda
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardOrganisasi()),
                    );
                    break;
                  case 1:
                    // Navigasi ke ListPesanPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListPesanPage()),
                    );
                    break;
                  case 3:
                    // Navigasi ke ProfileOrganisasi
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileOrganisasiPage()),
                    );
                    break;
                  case 2:
                    // Navigasi ke Penarikan
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PenarikanPage()),
                    );
                    break;
                }
              },
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
                  icon: Icon(Icons.money),
                  label: 'Penarikan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildFormScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Dana Tersedia',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rp 1.050.000',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Dana Ditarik',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                items: _bankList.map((String bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedBank = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pilih Bank Tujuan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_jumlahController.text.isNotEmpty &&
                      double.tryParse(_jumlahController.text) != null) {
                    setState(() {
                      isSuccess = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tarik Dana',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Penarikan Berhasil!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Total Penarikan:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${_jumlahController.text}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Tanggal Penarikan:'),
                  Text('23 Jan 2025'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rekening Tujuan:'),
                  Text(_selectedBank ?? '-'),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              // Bukti Pembayaran
              const Text(
                'Bukti Pembayaran:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Kode Transaksi: ABC123456',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bank Tujuan: Bank BCA',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Status: Berhasil',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardOrganisasi()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Dashboard',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}