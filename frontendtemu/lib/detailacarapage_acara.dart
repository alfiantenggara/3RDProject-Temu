import 'package:flutter/material.dart';
import 'package:frontendtemu/service/acara_service.dart'; // Import service acara
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'dart:convert'; // Untuk decode base64
import 'package:frontendtemu/chatPerusahaan/chat_detail_page.dart'; // Import layar chat detail
import 'package:frontendtemu/chat_model.dart'; // Import model chat
import 'beriuang.dart'; // Import layar beri uang
import 'package:frontendtemu/service/chat_service.dart'; // Import service chat

class DetailPageAcara extends StatefulWidget {
  final String acaraId; // Terima ID acara

  const DetailPageAcara({Key? key, required this.acaraId}) : super(key: key);

  @override
  State<DetailPageAcara> createState() => DetailPageAcaraState();
}

class DetailPageAcaraState extends State<DetailPageAcara> {
  bool isFavorited = false;
  bool isShared = false;
  int? idOrganisasi; // Simpan idOrganisasi di sini
  Map<String, dynamic>? acara; // Simpan data acara di sini
  bool isLoading = true; // Untuk menangani loading state

  @override
  void initState() {
    super.initState();
    // Ambil detail acara berdasarkan ID
    _fetchAcaraData();
  }

  // Fungsi untuk mengambil data acara
  Future<void> _fetchAcaraData() async {
    try {
      final response = await AcaraService().getById(widget.acaraId, context);
      if (response['success'] == true) {
        setState(() {
          acara = response['data'][0]; // Simpan data acara
          idOrganisasi = int.parse(acara!['organisasi']['id_organisasi'].toString()); // Setel idOrganisasi
          isLoading = false; // Tandai loading selesai
        });
      } else {
        throw Exception('Gagal mengambil data acara');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Tandai loading selesai
      });
    }
  }

  // Fungsi untuk membuka layar chat
  Future<void> _openChat(BuildContext context, int idOrganisasi) async {
    try {
      // Ambil data chat menggunakan endpoint getIdChatByTemanChat
      final response = await ChatService().getIdChatByTemanChat(idOrganisasi.toString(), context);
      if (response['success'] == true) {
        final dataChat = response['data']['dataChat'] as List; // Ambil data chat
        final idChat = response['data']['id_chat']; // Ambil idChat
        final namaTemanChat = response['data']['nama_teman_chat']; // Ambil nama teman chat

        // Navigasi ke ChatDetailPage dengan data yang didapat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              chat: Chat(
                idChat: idChat,
                unreadCount: 0, // Default value, bisa disesuaikan
                lastChat: dataChat.map((item) => LastChat.fromJson(item)).toList(),
                dataTemanBicara: TemanBicara(
                  id: idOrganisasi,
                  nama: namaTemanChat,
                ),
              ),
            ),
          ),
        );
      } else {
        throw Exception('Gagal mendapatkan data chat');
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (acara == null) {
      return Center(child: Text('Data acara tidak ditemukan.'));
    }

    // Format tanggal acara
    String formattedDate = acara!['tanggal_acara'] != null
        ? DateFormat('dd MMM yyyy').format(
            DateTime.parse(acara!['tanggal_acara']),
          )
        : 'Tanggal tidak tersedia';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: acara!['poster_acara'] ??
                            'https://via.placeholder.com/600x400',
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        base64Decode(acara!['poster_acara']), // Decode base64
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorited ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorited = !isFavorited;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isShared ? Icons.share : Icons.share_outlined,
                              color: isShared ? Colors.blue : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isShared = !isShared;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acara!['nama_acara'] ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            acara!['kota_berlangsung'] ?? 'Lokasi tidak tersedia',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Biaya Acara',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(acara!['biaya_dibutuhkan'] ?? 0),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lokasi Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        acara!['lokasi_acara'] ?? 'Lokasi tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Kegiatan Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        acara!['kegiatan_acara'] ?? 'Kegiatan tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Proposal Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Proposal tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () {
                  if (idOrganisasi != null) {
                    // Buka layar chat dengan idOrganisasi
                    _openChat(context, idOrganisasi!);
                  } else {
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 60),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeriUangPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Donasi Acara Ini',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}