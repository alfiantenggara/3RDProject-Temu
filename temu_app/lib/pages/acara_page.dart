import 'package:flutter/material.dart';
import 'package:temu_app/pages/addacarapage.dart';
import 'package:temu_app/model/acara.dart';
import 'package:temu_app/pages/detailacara_page.dart';
// import 'package:temu_app/service/acara_service.dart';
import 'package:temu_app/dummydata/dmmyacara.dart';

class AcaraPage extends StatefulWidget {
  const AcaraPage({super.key});

  @override
  _AcaraPageState createState() => _AcaraPageState();
}

class _AcaraPageState extends State<AcaraPage> {
  List<Acara> publishedAcara = [];
  bool isLoading = true; // Menambahkan indikator loading
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAcara();
  }

  Future<void> fetchAcara() async {
    try {
      // Jika fetching data API gagal, gunakan data dummy
      final acaraList = dummyData();
      // await AcaraService().getAcarafromApi();
      setState(() {
        publishedAcara = acaraList;
        isLoading = false;
      });
    } catch (e) {
      // Menangani error jika terjadi kegagalan pada fetching data API
      setState(() {
        errorMessage = "Gagal memuat acara: ${e.toString()}";
        publishedAcara = dummyData(); // Menampilkan data dummy
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
                                    DetailAcaraPage(acara: acara),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    acara.namaAcara ?? "Nama tidak tersedia",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    acara.kotaBerlangsung ??
                                        "Lokasi tidak tersedia",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Harga: Rp ${acara.biayaDibutuhkan}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
