import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addacarapage.dart';
import 'acara.dart';
import 'dmmyacara.dart';
import 'detailacarapage_perusahaan.dart';

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
                                    DetailPagePerusahaan(acara: acara),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: acara.gambarAcara != null
                                            ? Image.network(
                                                acara.gambarAcara!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
                                                      child: Icon(Icons
                                                          .image_not_supported));
                                                },
                                              )
                                            : const Center(
                                                child: Icon(Icons.image,
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
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
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 100,
                                                  maxWidth: 150,
                                                  minHeight: 40,
                                                  maxHeight: 60,
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          offset: const Offset(0, 40),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              acara.kotaBerlangsung ??
                                                  'Lokasi tidak tersedia',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          NumberFormat.currency(
                                                  locale: 'id_ID',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0)
                                              .format(acara.biayaDibutuhkan),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
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
