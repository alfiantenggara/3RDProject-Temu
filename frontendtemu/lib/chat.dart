import 'package:flutter/material.dart';

class ListPesanPage extends StatelessWidget {
  // Dummy data untuk list pesan
  final List<Map<String, String>> messages = [
    {
      'sender': 'Perusahaan A',
      'message': 'Halo, kami tertarik dengan proposal Anda.',
      'time': '10:00 AM',
    },
    {
      'sender': 'Perusahaan B',
      'message': 'Apakah Anda bisa mengirimkan detail lebih lanjut?',
      'time': '09:30 AM',
    },
    {
      'sender': 'Perusahaan C',
      'message': 'Terima kasih atas kerjasamanya!',
      'time': '08:45 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDED0CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pesan',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
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
                  message['sender']![0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                message['sender']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                message['message']!,
                style: TextStyle(fontSize: 14),
              ),
              trailing: Text(
                message['time']!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}