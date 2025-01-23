import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardPerusahaan.dart';
import 'package:frontendtemu/profilePerusahaan.dart';
import 'package:frontendtemu/service/chat_service.dart';
import 'package:frontendtemu/chat_model.dart';
import 'package:frontendtemu/chatPerusahaan/chat_detail_page.dart';

class ListPesanPage extends StatelessWidget {
  // Fungsi untuk mengambil data chat dari API
  Future<List<Chat>> fetchChats(BuildContext context) async {
    final response = await ChatService().getAll(context);
    if (response['success'] == true) {
      final data = response['data'] as List;
      return data.map((item) => Chat.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDED0CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Hilangkan tombol back
        title: const Text(
          'Pesan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Chat>>(
        future: fetchChats(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada pesan.'));
          } else {
            final chats = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final lastMessage = chat.lastChat.isNotEmpty
                    ? chat.lastChat.first
                    : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        chat.dataTemanBicara.nama[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      chat.dataTemanBicara.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: lastMessage != null
                        ? Text(
                            (lastMessage.pengirimIsSelf == true ? "You: " : "") + lastMessage.isiPesan,
                            style: TextStyle(fontSize: 14),
                          )
                        : Text(
                            'Tidak ada pesan',
                            style: TextStyle(fontSize: 14, color: Colors.red),
                          ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (lastMessage != null)
                          Text(
                            lastMessage.waktuKirim,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      // Navigasi ke layar chat detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(chat: chat),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Set index untuk halaman pesan
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              // Navigasi ke Beranda
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardPerusahaan()),
              );
              break;
            case 1:
              // Navigasi ke Pesan (tidak perlu navigasi karena sudah di halaman pesan)
              break;
            case 2:
              // Navigasi ke Profil
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePerusahaanPage()),
              );
              break;
          }
        },
      ),
    );
  }
}