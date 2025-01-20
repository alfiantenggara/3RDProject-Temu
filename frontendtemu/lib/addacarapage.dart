import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'acara.dart';
import 'acara_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:open_file/open_file.dart';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';

class AddAcaraPage extends StatefulWidget {
  const AddAcaraPage({super.key});

  @override
  State<AddAcaraPage> createState() => _AddAcaraPageState();
}

class _AddAcaraPageState extends State<AddAcaraPage> {
  String appBarTitle = "Buat Acara";
  List<Acara> publishedAcara = [];
  PlatformFile? selectedFile;
  bool isLoadingFile = false;
  String? errorMessage;
  FilePickerResult? selectfile;
  String? selectedFileName;
  File? uploadedFile;
  double uploadProgress = 0.0;
  bool isUploading = false;
  String? uploadStatus;
  PlatformFile? selectedImage;
  String? selectedImageName;
  String? imageUrl;
  Uint8List? selectedImageBytes; // Variabel untuk menyimpan byte gambar

  final _formKey = GlobalKey<FormState>();
  TextEditingController namaAcaraController = TextEditingController();
  TextEditingController tanggalAcaraController = TextEditingController();
  TextEditingController waktuAwalController = TextEditingController();
  TextEditingController waktuAkhirController = TextEditingController();
  TextEditingController lokasiAcaraController = TextEditingController();
  TextEditingController biayaDibutuhkanController = TextEditingController();
  TextEditingController kotaBerlangsungController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  final List<String> kegiatanList = ['Gunung', 'Sungai', 'Laut', 'Lembah'];
  String? selectedKegiatan;
  String? formattedDate;

  @override
  void dispose() {
    namaAcaraController.dispose();
    super.dispose();
  }

  Future<void> simulateFileUpload(Function(double) onProgress) async {
    double progress = 0.0;
    while (progress <= 1.0) {
      await Future.delayed(const Duration(milliseconds: 50));
      progress += 0.02; // Increment 2%
      onProgress(progress);
    }
  }

  Future<void> sendPostRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Ambil idOrganisasi terlebih dahulu dari API
        // String idOrganisasi = await fetchIdOrganisasi();

        final acara = {
          "idOrganisasi": ['idOrganisasi'],
          // idOrganisasi // ID Organisasi yang didapatkan dari API
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
        if (selectedFile != null) {
          if (kIsWeb) {
            // Handle web file upload
            if (selectedFile!.bytes != null) {
              // Tambahkan bytes file ke request
              acara['fileProposal'] = selectedFile!.bytes;
            }
          } else {
            // Handle mobile file upload
            if (selectedFile!.path != null) {
              final file = File(selectedFile!.path!);
              // Tambahkan file ke request
              acara['fileProposal'] = await file.readAsBytes();
            }
          }
        }

        bool isSuccess = await AcaraService().addOrUpdateAcara(acara);

        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Acara berhasil ditambahkan!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menambahkan acara!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil ID Organisasi!")),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void openSelectedImage() {
    if (selectedImage != null) {
      if (kIsWeb) {
        final bytes = selectedImage!.bytes;
        if (bytes != null) {
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          setState(() {
            imageUrl = url;
          });
        }
      }
    }
  }

  // Function to pick an image
  Future<void> pickImage(TextEditingController imageUrlController) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedImage = result.files.first;
        selectedImageName = selectedImage!.name;
        if (kIsWeb) {
          selectedImageBytes = selectedImage!.bytes;
        } else {
          imageUrlController.text = selectedImage!.path!;
        }
      });
    }
  }

  // Function to remove the selected image
  void removeSelectedImage() {
    setState(() {
      selectedImage = null;
      selectedImageName = null;
      imageUrl = null;
    });
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
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Menempatkan title di tengah
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 10.0), // Menempatkan tombol Cancel di kiri
          child: TextButton(
            onPressed: () {
              // Aksi untuk tombol Cancel
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFD9EAFD),
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize:
                  const Size(100, 40), // Ukuran minimal tombol (lebar, tinggi)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
              ),
            ),
            child: const Text(
              "Batal", // Tombol dengan teks "Cancel"
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Menempatkan tombol Add Acara di kanan
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton.icon(
                    onPressed:
                        showConfirmationDialog, // Menampilkan dialog saat ditekan
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFD9EAFD),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(
                          100, 40), // Ukuran minimal tombol (lebar, tinggi)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Sudut melengkung
                      ),
                    ),

                    label: const Text(
                      "Add Acara",
                      style: TextStyle(color: Colors.black, fontSize: 14),
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
              const Text(
                "Upload Poster Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => pickImage(imageUrlController),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Pilih Poster'),
                    ),
                    if (selectedImage != null ||
                        imageUrlController.text.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: buildSelectedImage(imageUrlController),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'File yang dipilih: ${selectedImageName ?? ""}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            imageUrlController.clear();
                            selectedImage = null;
                            selectedImageBytes = null;
                          });
                        },
                        child: const Text(
                          "Hapus Poster",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Data Acara",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: namaAcaraController,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan Judul Acara ',
                              filled: true,
                              fillColor: const Color(0xffEFF3EA),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Nama acara tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Tanggal Acara",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: tanggalAcaraController,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.calendar_today),
                              hintText: formattedDate ??
                                  'Pilih Tanggal', // Menggunakan formattedDate yang disimpan
                              iconColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color(0xffEFF3EA),
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
                                        primary:
                                            Colors.teal, // Warna tombol utama
                                        onPrimary:
                                            Colors.white, // Teks tombol utama
                                        surface: Colors
                                            .white, // Latar belakang picker
                                        onSurface:
                                            Colors.black, // Teks di picker
                                      ),
                                      dialogBackgroundColor: Colors
                                          .white, // Latar belakang dialog picker

                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.teal, // Warna tombol teks
                                        ),
                                      ),
                                      // Ubah latar belakang dan teks tanggal yang dipilih
                                      buttonTheme: const ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary,
                                        buttonColor:
                                            Colors.teal, // Warna tombol
                                      ),
                                      // Menyesuaikan tanggal yang dipilih (highlighted date background)
                                      scaffoldBackgroundColor: Colors
                                          .white, // Latar belakang area tanggal
                                      textTheme: const TextTheme(
                                        bodyLarge: TextStyle(
                                            color: Colors
                                                .black), // Warna teks di tanggal
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  formattedDate = DateFormat('EEEE, dd-MM-yyyy')
                                      .format(selectedDate);
                                  tanggalAcaraController.text = formattedDate!;
                                });
                              }
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Tanggal acara tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(height: 15),
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
                                        Icon(Icons.access_time,
                                            color: Colors.red),
                                        SizedBox(
                                            width:
                                                4), // Jarak kecil antara ikon dan teks
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
                                        height:
                                            4), // Spasi kecil antara label dan field
                                    GestureDetector(
                                      onTap: () =>
                                          selectTime(waktuAwalController),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller: waktuAwalController,
                                          decoration: InputDecoration(
                                            iconColor: Colors.red,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffEFF3EA),
                                          ),
                                          validator: (value) => value == null ||
                                                  value.isEmpty
                                              ? 'Waktu awal tidak boleh kosong'
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8), // Spacing antara kolom kiri dan kanan
                              // Waktu Akhir
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            color: Colors.blue),
                                        SizedBox(
                                            width:
                                                4), // Jarak kecil antara ikon dan teks
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
                                        height:
                                            4), // Spasi kecil antara label dan field
                                    GestureDetector(
                                      onTap: () =>
                                          selectTime(waktuAkhirController),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller: waktuAkhirController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xffEFF3EA),
                                          ),
                                          validator: (value) => value == null ||
                                                  value.isEmpty
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
                          const SizedBox(height: 15),
                          const Text(
                            "Lokasi Acara",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: lokasiAcaraController,
                            maxLines: null,
                            minLines: 4, // Menentukan tinggi minimum (1 baris)
                            // Mengizinkan multiline (otomatis menyesuaikan tinggi)
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color(0xffEFF3EA),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasi acara tidak boleh kosong';
                              }
                              final wordCount =
                                  value.trim().split(RegExp(r'\s+')).length;
                              if (wordCount > 300) {
                                return 'Lokasi acara tidak boleh lebih dari 300 kata';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Biaya Acara(RAB)",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: biayaDibutuhkanController,
                            decoration: InputDecoration(
                              hintText: 'Cth: 100.000',
                              prefixText: 'Rp ',
                              suffixText: ',00',
                              suffixStyle: const TextStyle(color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              filled: true,
                              fillColor: const Color(0xffEFF3EA),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                if (newValue.text.isEmpty) {
                                  return newValue;
                                }
                                final parsed = int.tryParse(newValue.text);
                                if (parsed != null && parsed > 0) {
                                  final formatted =
                                      NumberFormat('#,###', 'id_ID')
                                          .format(parsed);
                                  return TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(
                                        offset: formatted.length),
                                  );
                                }
                                return oldValue;
                              }),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Biaya dibutuhkan tidak boleh kosong';
                              }
                              final parsedValue =
                                  int.tryParse(value.replaceAll(',', ''));
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
                          const Text(
                            "Jenis Kegiatan",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            value: selectedKegiatan,
                            decoration: InputDecoration(
                              labelText: 'Kegiatan',
                              labelStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black), // Ubah ukuran label
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
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
                            dropdownColor:
                                Colors.white, // Warna latar belakang dropdown
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.teal), // Warna ikon
                            style: const TextStyle(
                                color: Colors.black), // Warna teks dropdown
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Kota Berlangsungnya Acara",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: kotaBerlangsungController,
                            decoration: InputDecoration(
                              labelText: 'Kota',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                              filled: true,
                              fillColor: const Color(0xffEFF3EA),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Nama kota tidak boleh kosong'
                                : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(height: 24),

                          // File Upload Section - Separate container at the same level
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade50,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Unggah File Proposal',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Your file picker code
                                      },
                                      child: const Text('Pilih File'),
                                    ),
                                    const SizedBox(width: 12),
                                    if (isUploading)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LinearProgressIndicator(
                                                value: uploadProgress),
                                            const SizedBox(height: 4),
                                            Text(
                                              uploadStatus ?? 'Uploading...',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else if (selectedFileName != null)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                selectedFile?.extension
                                                            ?.toLowerCase() ==
                                                        'pdf'
                                                    ? Icons.picture_as_pdf
                                                    : Icons.insert_drive_file,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  selectedFileName!,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.open_in_new,
                                                    size: 20),
                                                onPressed: openSelectedFile,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                tooltip: 'Buka file',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openSelectedFile() {
    if (selectedFile != null) {
      // Check if it's a web platform
      if (kIsWeb) {
        // Get the file extension to check if it's PDF
        final fileExtension = selectedFile!.name.split('.').last.toLowerCase();

        if (fileExtension == 'pdf') {
          // For PDF files, create a Blob URL and open it in the browser
          final bytes = selectedFile!.bytes;
          if (bytes != null) {
            // Create a Blob object from the file bytes and specify MIME type as 'application/pdf'
            final blob = html.Blob([bytes], 'application/pdf');

            // Create a URL for the Blob object
            final url = html.Url.createObjectUrlFromBlob(blob);

            // Open the PDF in a new browser tab (the browser will render it as a PDF)
            html.window.open(url, '_blank'); // This opens the PDF in a new tab

            // Revoke the Blob URL after use to free memory
            html.Url.revokeObjectUrl(url);
          }
        } else {
          // Handle non-PDF files (e.g., DOCX, etc.)
          final fileUrl = selectedFile!.path;
          if (fileUrl != null) {
            html.window.open(fileUrl, '_blank');
          }
        }
      } else {
        // For mobile/desktop, use OpenFile to open the file with the default application
        if (selectedFile!.path != null) {
          OpenFile.open(selectedFile!.path);
        }
      }
    }
  }

  buildSelectedImage(TextEditingController imageUrlController) {
    if (kIsWeb && selectedImageBytes != null) {
      return Image.memory(
        selectedImageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    // For non-Web platforms, using file path
    else if (!kIsWeb && imageUrlController.text.isNotEmpty) {
      return Image.file(
        File(imageUrlController.text),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    // Return an empty space if no image
    return const SizedBox.shrink();
  }
}
