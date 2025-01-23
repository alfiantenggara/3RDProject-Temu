// chat_detail_page.dart
import 'package:flutter/material.dart';
import 'package:frontendtemu/chat_model.dart'; // Import model chat
import 'package:frontendtemu/chatPerusahaan/chat.dart'; // Import model chat
import 'package:frontendtemu/service/chat_service.dart'; // Import service pesan

class ChatDetailPage extends StatefulWidget {
  final Chat chat; // Data chat yang dipilih

  const ChatDetailPage({required this.chat});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<LastChat> _messages = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService(); // Buat instance ChatService

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fungsi untuk mengambil data pesan dari API
  Future<void> _fetchMessages() async {
    try {
      final response = await _chatService.getMessages(
        widget.chat.dataTemanBicara.id.toString(), // Menggunakan idTemanBicara sebagai String
        context,
      );
      if (response['success'] == true) {
        final data = response['data'] as List;
        setState(() {
          _messages.addAll(data.map((item) => LastChat.fromJson(item)).toList());
          _isLoading = false;
        });
        _scrollToBottom(); // Scroll ke bagian bawah setelah mengambil pesan
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Fungsi untuk mengirim pesan
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        await _chatService.sendMessage(
          widget.chat.dataTemanBicara.id.toString(), // Menggunakan idTemanBicara sebagai String
          message,
          context,
        );
        setState(() {
          _messages.add(
            LastChat(
              pengirimIsSelf: true,
              waktuKirim: DateTime.now().toString(),
              dibaca: 0,
              waktuBaca: null,
              isiPesan: message,
            ),
          );
        });
        _messageController.clear();
        _scrollToBottom(); // Scroll ke bagian bawah setelah mengirim pesan
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  // Fungsi untuk scroll ke bagian bawah
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDED0CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true, // Aktifkan tombol back
        title: Text(
          widget.chat.dataTemanBicara.nama,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icon back
          onPressed: () {
            // Kembali ke layar list chat
            Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListPesanPage()),
                    );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget terpisah untuk menampilkan pesan
class MessageBubble extends StatelessWidget {
  final LastChat message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.pengirimIsSelf
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.pengirimIsSelf ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.isiPesan,
          style: TextStyle(
            color: message.pengirimIsSelf ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}