import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../model/acara.dart';
import '../service/acara_service.dart';

class AddAcaraPage extends StatefulWidget {
  const AddAcaraPage({Key? key}) : super(key: key);

  @override
  _AddAcaraPageState createState() => _AddAcaraPageState();
}

class _AddAcaraPageState extends State<AddAcaraPage> {
  String appBarTitle = "Tambah Acara";
  List<Acara> publishedAcara = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaAcaraController = TextEditingController();
  TextEditingController tanggalAcaraController = TextEditingController();
  TextEditingController waktuAwalController = TextEditingController();
  TextEditingController waktuAkhirController = TextEditingController();
  TextEditingController lokasiAcaraController = TextEditingController();
  TextEditingController biayaDibutuhkanController = TextEditingController();
  TextEditingController kotaBerlangsungController = TextEditingController();
  bool isLoading = false;

  final List<String> kegiatanList = ['Gunung', 'Sungai', 'Laut', 'Lembah'];
  String? selectedKegiatan;
  String? formattedDate;

  @override
  void initState() {
    super.initState();

    namaAcaraController.addListener(() {
      setState(() {
        appBarTitle = namaAcaraController.text.isNotEmpty
            ? namaAcaraController.text
            : "Tambah Acara";
      });
    });
  }

  @override
  void dispose() {
    namaAcaraController.dispose();
    super.dispose();
  }

  Future<void> sendPostRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final acara = {
        "idOrganisasi": ['idOrganisasi'],
        "namaAcara": namaAcaraController.text,
        "tanggalAcara": tanggalAcaraController.text,
        "lokasiAcara": lokasiAcaraController.text,
        "biayaDibutuhkan": biayaDibutuhkanController.text,
        "kegiatanAcara": selectedKegiatan,
        "kotaBerlangsung": kotaBerlangsungController.text,
        "detailWaktu": [
          {
            "waktuMulai": waktuAwalController.text,
            "waktuSelesai": waktuAkhirController.text,
          },
        ],
      };
      bool isSuccess = await AcaraService().addOrUpdateAcara(acara);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Acara berhasil ditambahkan!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan acara!")),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showConfirmationDialog() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin mempublish acara?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Jika memilih "Tidak"
              },
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Jika memilih "Ya"
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      sendPostRequest();
      Navigator.pop(context);
    }
  }

  // Function to open time picker
  Future<void> selectTime(TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal, // Warna aksen pada picker
            primaryColorDark:
                Colors.teal, // Warna gelap untuk waktu yang dipilih
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: Colors.teal, // Tombol pilihan
            ),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9EAFD),
        title: Text(appBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton.icon(
                    onPressed:
                        showConfirmationDialog, // Menampilkan dialog saat ditekan
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE8EAFD),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(
                          130, 44), // Ukuran minimal tombol (lebar, tinggi)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Sudut melengkung
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Add Acara",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: namaAcaraController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan Judul Acara ',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama acara tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 10),
              const Text(
                "Tanggal dan Waktu Acara",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              TextFormField(
                controller: tanggalAcaraController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: formattedDate ??
                      'Pilih Tanggal', // Menggunakan formattedDate yang disimpan
                  iconColor: Colors.grey,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: InputBorder.none,
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.teal, // Warna tombol utama
                            onPrimary: Colors.white, // Teks tombol utama
                            surface: Colors.white, // Latar belakang picker
                            onSurface: Colors.black, // Teks di picker
                          ),
                          dialogBackgroundColor:
                              Colors.white, // Latar belakang dialog picker

                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.teal, // Warna tombol teks
                            ),
                          ),
                          // Ubah latar belakang dan teks tanggal yang dipilih
                          buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                            buttonColor: Colors.teal, // Warna tombol
                          ),
                          // Menyesuaikan tanggal yang dipilih (highlighted date background)
                          scaffoldBackgroundColor:
                              Colors.white, // Latar belakang area tanggal
                          textTheme: const TextTheme(
                            bodyLarge: TextStyle(
                                color: Colors.black), // Warna teks di tanggal
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedDate != null) {
                    setState(() {
                      formattedDate =
                          DateFormat('EEEE, dd-MM-yyyy').format(selectedDate);
                      tanggalAcaraController.text = formattedDate!;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal acara tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Mengatur posisi kiri dan kanan
                children: [
                  // Waktu Awal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.red),
                            SizedBox(
                                width: 4), // Jarak kecil antara ikon dan teks
                            Text(
                              "Waktu Awal",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 4), // Spasi kecil antara label dan field
                        GestureDetector(
                          onTap: () => selectTime(waktuAwalController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: waktuAwalController,
                              decoration: InputDecoration(
                                iconColor: Colors.red,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Waktu awal tidak boleh kosong'
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Spacing antara kolom kiri dan kanan
                  // Waktu Akhir
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue),
                            SizedBox(
                                width: 4), // Jarak kecil antara ikon dan teks
                            Text(
                              "Waktu Akhir",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 4), // Spasi kecil antara label dan field
                        GestureDetector(
                          onTap: () => selectTime(waktuAkhirController),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: waktuAkhirController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Waktu akhir tidak boleh kosong'
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lokasiAcaraController,
                maxLines:
                    null, // Mengizinkan multiline (otomatis menyesuaikan tinggi)
                decoration: const InputDecoration(
                  labelText: 'Lokasi Acara',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi acara tidak boleh kosong';
                  }
                  final wordCount = value.trim().split(RegExp(r'\s+')).length;
                  if (wordCount > 300) {
                    return 'Lokasi acara tidak boleh lebih dari 300 kata';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: biayaDibutuhkanController,
                decoration: InputDecoration(
                  labelText: 'Biaya Dibutuhkan',
                  hintText: 'Masukkan biaya dalam Rupiah',
                  prefixText: 'Rp ',
                  suffixText: ',00',
                  suffixStyle: const TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final parsed = int.tryParse(newValue.text);
                    if (parsed != null && parsed > 0) {
                      final formatted =
                          NumberFormat('#,###', 'id_ID').format(parsed);
                      return TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                    return oldValue;
                  }),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Biaya dibutuhkan tidak boleh kosong';
                  }
                  final parsedValue = int.tryParse(value.replaceAll(',', ''));
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Biaya harus berupa angka positif';
                  }
                  if (parsedValue < 50000) {
                    return 'Biaya minimal adalah Rp 50,000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedKegiatan,
                decoration: InputDecoration(
                  labelText: 'Kegiatan',
                  labelStyle: const TextStyle(
                      fontSize: 14, color: Colors.black), // Ubah ukuran label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                isDense: true, // Membuat dropdown lebih padat
                isExpanded: false, // Membatasi lebar dropdown
                items: kegiatanList.map((String kegiatan) {
                  return DropdownMenuItem<String>(
                    value: kegiatan,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4), // Memberi padding per item
                      child: Text(
                        kegiatan,
                        style: const TextStyle(
                            fontSize: 14), // Sesuaikan ukuran font
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKegiatan = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Pilih kegiatan acara'
                    : null,
                dropdownColor: Colors.white, // Warna latar belakang dropdown
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.teal), // Warna ikon
                style:
                    const TextStyle(color: Colors.black), // Warna teks dropdown
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: kotaBerlangsungController,
                decoration: const InputDecoration(labelText: 'Kota'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama kota tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
