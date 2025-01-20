import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileOrganisasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Organisasi',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                        Icons.people,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Profil',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildTextFieldLabel('Nama Organisasi'),
              _buildTextField(
                icon: Icons.group,
                hint: 'Masukkan nama organisasi',
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Alamat E-Mail Organisasi'),
              _buildTextField(
                icon: Icons.email,
                hint: 'Masukkan email organisasi',
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Kota Domisili Organisasi'),
              DropdownButtonFormField<String>(
                items: ['Jakarta', 'Bandung', 'Surabaya']
                    .map((city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: GoogleFonts.poppins(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {},
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Nomor Telepon Organisasi'),
              _buildTextField(
                icon: Icons.phone,
                prefix: '+62',
                hint: 'Masukkan nomor telepon',
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Deskripsi Organisasi'),
              _buildTextField(
                icon: Icons.description,
                hint: 'Masukkan deskripsi singkat organisasi',
                maxLines: 3,
              ),
              SizedBox(height: 32),
              Text(
                'Penanggung Jawab Organisasi',
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
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Jabatan'),
              _buildTextField(
                icon: Icons.work,
                hint: 'Masukkan jabatan',
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Alamat E-Mail'),
              _buildTextField(
                icon: Icons.email,
                hint: 'Masukkan email',
              ),
              SizedBox(height: 16),
              _buildTextFieldLabel('Alamat Lengkap'),
              _buildTextField(
                icon: Icons.location_on,
                hint: 'Masukkan alamat lengkap',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
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
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return TextFormField(
      obscureText: obscureText,
      maxLines: maxLines,
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
