import 'package:flutter/material.dart';
import 'package:frontendtemu/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service/auth_service.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class LoginOrganisasi extends StatefulWidget {
  const LoginOrganisasi({Key? key}) : super(key: key);

  @override
  _LoginOrganisasiState createState() => _LoginOrganisasiState();
}

class _LoginOrganisasiState extends State<LoginOrganisasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  bool isObscure = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = kataSandiController.text;

      print("Login attempt for $email");

      final authService = AuthService();
      bool success = await authService.login(email, password, context);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login gagal, coba lagi.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OnboardingPage()),
            (route) => false,
          );
          },
        ),
        title: const Text('Masuk'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Organisasi',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  return TextFormField(
                    controller: kataSandiController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      labelStyle: GoogleFonts.poppins(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
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
                        MaterialPageRoute(
                            builder: (context) => const DaftarOrganisasi()),
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
      ),
    );
  }
}

class DaftarOrganisasi extends StatefulWidget {
  const DaftarOrganisasi({Key? key}) : super(key: key);

  @override
  _DaftarOrganisasiState createState() => _DaftarOrganisasiState();
}

class _DaftarOrganisasiState extends State<DaftarOrganisasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaOrganisasiController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailPenanggungJawabController =
      TextEditingController();
  final TextEditingController kotaDomisiliController = TextEditingController();
  final TextEditingController nomorTeleponController = TextEditingController();
  final TextEditingController kataSandiController = TextEditingController();
  final TextEditingController penanggungJawabController =
      TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatLengkapController = TextEditingController();
  bool isAgreed = false;
  bool isObscure = true;
  File? ktpFile; // State buat nyimpen file KTP
  var resultKTP;

  Future<void> registerOrganisasi() async {
    if (_formKey.currentState!.validate() && isAgreed) {
      final email = emailController.text;
      final namaOrganisasi = namaOrganisasiController.text;
      final kotaDomisili = kotaDomisiliController.text;
      final penanggungJawab = penanggungJawabController.text;
      final tanggalLahir = tanggalLahirController.text;
      final alamatLengkap = alamatLengkapController.text;
      final nomorTelepon = nomorTeleponController.text;
      final emailPenanggungJawab = emailPenanggungJawabController.text;
      final kataSandi = kataSandiController.text;

      final ktpBase64 = ktpFile != null
          ? (kIsWeb
              ? base64Encode(
                  resultKTP.files.single.bytes!) // Langsung dari FilePickerResult
              : base64Encode(ktpFile!.readAsBytesSync())) // Native
          : 'pathToFile';

      print("Register attempt for $email");

      final authService = AuthService();
      var data = await authService.register_organisasi(
          email,
          namaOrganisasi,
          kotaDomisili,
          penanggungJawab,
          tanggalLahir,
          alamatLengkap,
          nomorTelepon,
          emailPenanggungJawab,
          kataSandi,
          ktpBase64,
          context);
      if (!data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register gagal, coba lagi.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua form sudah diisi.')),
      );
    }
  }

  Future<void> pickKTPImage() async {
    try {
      final picker = ImagePicker();
      if (kIsWeb) {
        // Handle web file pick
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null && result.files.single.bytes != null) {
          setState(() {
            ktpFile = File(result
                .files.single.name); // Optional buat nyimpen nama file doang
              resultKTP = result;
          });
        } else {
          print('Tidak ada file yang dipilih.');
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            ktpFile = File(pickedFile.path);
          });
        } else {
          print('No file selected.');
        }
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

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
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: namaOrganisasiController,
                decoration: InputDecoration(
                  labelText: 'Nama Organisasi',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Alamat E-Mail',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: kotaDomisiliController,
                decoration: InputDecoration(
                  labelText: 'Kota Domisili Organisasi',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nomorTeleponController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon Organisasi',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: kataSandiController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
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
                controller: penanggungJawabController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tanggalLahirController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    tanggalLahirController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailPenanggungJawabController,
                decoration: InputDecoration(
                  labelText: 'Email Penanggung Jawab',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.mail),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: alamatLengkapController,
                decoration: InputDecoration(
                  labelText: 'Alamat Lengkap',
                  labelStyle: GoogleFonts.poppins(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: pickKTPImage,
                icon: const Icon(Icons.upload),
                label: const Text('Unggah KTP'),
              ),
              if (ktpFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'KTP berhasil diunggah: ${ktpFile!.path.split('/').last}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (value) {
                      setState(() {
                        isAgreed = value ?? false;
                      });
                    },
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
                  onPressed: registerOrganisasi,
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
      ),
    );
  }
}