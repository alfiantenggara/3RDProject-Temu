import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontendtemu/service/auth_service.dart';
import 'package:frontendtemu/loginperusahaan.dart';
import 'package:frontendtemu/dashboardperusahaan.dart';

class ProfilePerusahaanPage extends StatefulWidget {
  @override
  _ProfilePerusahaanPageState createState() => _ProfilePerusahaanPageState();
}

class _ProfilePerusahaanPageState extends State<ProfilePerusahaanPage> {
  late Future<Map<dynamic, dynamic>> _userDataFuture;
  final AuthService _authService = AuthService();

  // Controller untuk TextField
  final TextEditingController _namaPerusahaanController = TextEditingController();
  final TextEditingController _kotaDomisiliController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatLengkapController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userDataFuture = _authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userDataFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(child: Text('Error loading data: ${userSnapshot.error}')),
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

          // Ambil data perusahaan dan penanggung jawab dari response
          final perusahaanData = userData['data'];
          final penanggungJawabData = perusahaanData['penanggungJawab'];

          // Set nilai awal TextField
          if (_namaPerusahaanController.text.isEmpty) {
            _namaPerusahaanController.text = perusahaanData['namaPerusahaan'] ?? 'Nama Perusahaan Tidak Diketahui';
          }
          if (_kotaDomisiliController.text.isEmpty) {
            _kotaDomisiliController.text = perusahaanData['kotaDomisiliPerusahaan'] ?? 'Kota Tidak Diketahui';
          }
          if (_nomorTeleponController.text.isEmpty) {
            _nomorTeleponController.text = perusahaanData['nomorTeleponPerusahaan'] ?? 'Telepon Tidak Diketahui';
          }
          if (_namaLengkapController.text.isEmpty) {
            _namaLengkapController.text = penanggungJawabData['namaLengkap'] ?? 'Nama Lengkap Tidak Diketahui';
          }
          if (_tanggalLahirController.text.isEmpty) {
            _tanggalLahirController.text = penanggungJawabData['tanggalLahir'] ?? 'Tanggal Lahir Tidak Diketahui';
          }
          if (_alamatLengkapController.text.isEmpty) {
            _alamatLengkapController.text = penanggungJawabData['alamatLengkap'] ?? 'Alamat Tidak Diketahui';
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = penanggungJawabData['email'] ?? 'Email Tidak Diketahui';
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Profil Perusahaan',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.grey[200],
              elevation: 0,
              automaticallyImplyLeading: false, // Menghilangkan tombol back
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Profil Perusahaan',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildTextFieldLabel('Nama Perusahaan'),
                    _buildTextField(
                      icon: Icons.business,
                      hint: 'Masukkan nama perusahaan',
                      controller: _namaPerusahaanController,
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Kota Domisili Perusahaan'),
                    _buildTextField(
                      icon: Icons.location_city,
                      hint: 'Masukkan kota domisili',
                      controller: _kotaDomisiliController,
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Nomor Telepon Perusahaan'),
                    _buildTextField(
                      icon: Icons.phone,
                      prefix: '+62',
                      hint: 'Masukkan nomor telepon',
                      controller: _nomorTeleponController,
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Penanggung Jawab Perusahaan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Nama Lengkap'),
                    _buildTextField(
                      icon: Icons.person,
                      hint: 'Masukkan nama lengkap',
                      controller: _namaLengkapController,
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Tanggal Lahir'),
                    _buildTextField(
                      icon: Icons.calendar_today,
                      hint: 'Masukkan tanggal lahir',
                      controller: _tanggalLahirController,
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Alamat Lengkap'),
                    _buildTextField(
                      icon: Icons.location_on,
                      hint: 'Masukkan alamat lengkap',
                      controller: _alamatLengkapController,
                    ),
                    SizedBox(height: 16),
                    _buildTextFieldLabel('Email'),
                    _buildTextField(
                      icon: Icons.email,
                      hint: 'Masukkan email',
                      controller: _emailController,
                    ),
                    SizedBox(height: 32),
                    // Row untuk menata tombol Simpan Perubahan dan Logout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Tombol Simpan Perubahan
                        ElevatedButton(
                          onPressed: () async {
                            final result = await _authService.updatePerusahaanDanPenanggungJawab(
                              context: context,
                              namaPerusahaan: _namaPerusahaanController.text,
                              kotaDomisiliPerusahaan: _kotaDomisiliController.text,
                              nomorTeleponPerusahaan: _nomorTeleponController.text,
                              namaLengkapPenanggungJawab: _namaLengkapController.text,
                              tanggalLahirPenanggungJawab: _tanggalLahirController.text,
                              alamatLengkapPenanggungJawab: _alamatLengkapController.text,
                              emailPenanggungJawab: _emailController.text,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message'] ?? 'Data berhasil diupdate!'),
                                backgroundColor: result['success'] ? Colors.green : Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(
                            'Simpan Perubahan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Tombol Logout
                        ElevatedButton(
                          onPressed: () async {
                            // Logika logout
                            await _authService.logout(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPerusahaan()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: 3, // Set index untuk halaman profil
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
                  icon: Icon(Icons.history),
                  label: 'Riwayat',
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
                    // Navigasi ke Beranda
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPerusahaan()),
                    );
                    break;
                  case 1:
                    // Navigasi ke Pesan
                    Navigator.pushReplacementNamed(context, '/pesan');
                    break;
                  case 2:
                    // Navigasi ke Riwayat
                    Navigator.pushReplacementNamed(context, '/riwayat');
                    break;
                  case 3:
                    // Navigasi ke Profil (tidak perlu navigasi karena sudah di halaman profil)
                    break;
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    String? prefix,
    String? hint,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefix: prefix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  prefix,
                  style: GoogleFonts.poppins(),
                ),
              )
            : null,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}