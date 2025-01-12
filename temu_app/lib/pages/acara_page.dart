import 'package:flutter/material.dart';
import 'package:temu_app/pages/addacarapage.dart';
import 'package:temu_app/model/acara.dart';
import 'package:temu_app/pages/detailacarapage_acara.dart';
import 'package:temu_app/dummydata/dmmyacara.dart';

class AcaraPage extends StatefulWidget {
  const AcaraPage({super.key});

  @override
  _AcaraPageState createState() => _AcaraPageState();
}

class _AcaraPageState extends State<AcaraPage> {
  List<Acara> publishedAcara = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAcara();
  }

  Future<void> fetchAcara() async {
    try {
      final userId = getCurrentUserId();
      final acaraList = dummyData();
      final filteredAcara =
          acaraList.where((acara) => acara.idOrganisasi == userId).toList();
      setState(() {
        publishedAcara = filteredAcara;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Gagal memuat acara: ${e.toString()}";
        publishedAcara =
            dummyData().where((acara) => acara.idOrganisasi == 0).toList();
        isLoading = false;
      });
    }
  }

  void addAcara(Acara acara) {
    setState(() {
      publishedAcara.add(acara);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${acara.namaAcara} berhasil ditambahkan!')),
    );
  }

  void deleteAcara(Acara acara) {
    setState(() {
      publishedAcara.remove(acara);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${acara.namaAcara} berhasil dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9EAFD),
        title: const Text('Halaman Acara'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final result = await Navigator.push<Acara>(
                context,
                MaterialPageRoute(builder: (context) => const AddAcaraPage()),
              );
              if (result != null) {
                addAcara(result);
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: const Text(
              'Buat Acara',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : publishedAcara.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Belum ada acara yang dipublikasikan'),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: publishedAcara.length,
                      itemBuilder: (context, index) {
                        final acara = publishedAcara[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPageAcara(acara: acara),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              acara.namaAcara ??
                                                  "Nama tidak tersedia",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              acara.kotaBerlangsung ??
                                                  "Lokasi tidak tersedia",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Harga: Rp ${acara.biayaDibutuhkan}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'hapus') {
                                        deleteAcara(acara);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'hapus',
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minWidth: 100, // Lebar minimum
                                            maxWidth: 150,
                                            minHeight: 50,
                                            maxHeight: 100, // Lebar maksimum
                                          ),
                                          child: const ListTile(
                                            leading: Icon(Icons.delete,
                                                color: Colors.red),
                                            title: Text(
                                              'Hapus',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    icon: const Icon(Icons.more_vert),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Membuat sudut melengkung
                                    ),
                                    offset: Offset(0,
                                        40), // Mengatur posisi pop-up menu relatif terhadap tombol
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
