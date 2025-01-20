import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOrganisasi extends StatelessWidget {
  const LoginOrganisasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Masuk'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang Kembali ke TEMU',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Organisasi',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (context, setState) {
                bool isObscure = true;
                return TextField(
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LupaKataSandiOrganisasi()),
                  );
                },
                child: const Text('Lupa Kata Sandi?'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text('Masuk'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum Punya Akun? '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DaftarOrganisasi()),
                    );
                  },
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DaftarOrganisasi extends StatelessWidget {
  const DaftarOrganisasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Daftar'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yuk Daftarkan Organisasi Kamu ke TEMU',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Organisasi',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat E-Mail',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kota Domisili Organisasi',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_city),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nomor Telepon Organisasi',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (context, setState) {
                bool isObscure = true;
                return TextField(
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Penanggung Jawab Organisasi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.calendar_today),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                // Handle pickedDate
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat E-Mail',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat Lengkap',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.upload),
              label: const Text('Unggah KTP'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Text(
                    'Saya setuju dengan Syarat & Ketentuan yang Berlaku di TEMU',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text('Daftar'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sudah Punya Akun? '),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LupaKataSandiOrganisasi extends StatelessWidget {
  const LupaKataSandiOrganisasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Lupa Kata Sandi'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang Kembali ke TEMU',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Organisasi',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Alamat E-Mail',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                child: const Text('Kirim Kode ke E-Mail'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
