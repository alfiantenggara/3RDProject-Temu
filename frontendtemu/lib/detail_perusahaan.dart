import 'package:flutter/material.dart';
import 'package:frontendtemu/chatPerusahaan/chat_detail_page.dart'; // Import layar chat detail
import 'package:frontendtemu/chat_model.dart'; // Import model chat
import 'package:frontendtemu/service/chat_service.dart'; // Import service chat

class DetailPerusahaanPage extends StatelessWidget {
  final String name;
  final String location;
  final String phone;
  final String email;
  final String idPerusahaan; // Tambahkan idPerusahaan

  const DetailPerusahaanPage({
    Key? key,
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.idPerusahaan, // Terima idPerusahaan
  }) : super(key: key);

  // Fungsi untuk membuka layar chat
  Future<void> _openChat(BuildContext context, String idPerusahaan) async {
    try {
      // Ambil data chat menggunakan endpoint getIdChatByTemanChat
      final response = await ChatService().getIdChatByTemanChat(idPerusahaan, context);
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
                  id: int.parse(idPerusahaan), // Konversi idPerusahaan ke int
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Perusahaan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lokasi: $location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Telepon: $phone',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            // Tambahkan informasi lainnya sesuai kebutuhan
          ],
        ),
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
                  // Buka layar chat dengan idPerusahaan
                  _openChat(context, idPerusahaan);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
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
          ],
        ),
      ),
    );
  }
}