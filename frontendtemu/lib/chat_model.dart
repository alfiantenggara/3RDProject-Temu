// chat_model.dart
class Chat {
  final int unreadCount;
  final List<LastChat> lastChat;
  final TemanBicara dataTemanBicara;
  final int idChat;

  Chat({
    required this.unreadCount,
    required this.lastChat,
    required this.dataTemanBicara,
    required this.idChat,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      unreadCount: json['unreadCount'] ?? 0,
      lastChat: (json['lastChat'] as List? ?? [])
          .map((item) => LastChat.fromJson(item))
          .toList(),
      dataTemanBicara: TemanBicara.fromJson(json['dataTemanBicara'] ?? {}),
      idChat: json['idChat'] ?? 0,
    );
  }
}

class LastChat {
  final bool pengirimIsSelf;
  final String waktuKirim;
  final int dibaca;
  final String? waktuBaca;
  final String isiPesan;

  LastChat({
    required this.pengirimIsSelf,
    required this.waktuKirim,
    required this.dibaca,
    this.waktuBaca,
    required this.isiPesan,
  });

  factory LastChat.fromJson(Map<String, dynamic> json) {
    return LastChat(
      pengirimIsSelf: json['pengirimIsSelf'] ?? false,
      waktuKirim: json['waktu_kirim'] ?? '',
      dibaca: json['dibaca'] ?? 0,
      waktuBaca: json['waktu_baca'],
      isiPesan: json['isi_pesan'] ?? '',
    );
  }
}

class TemanBicara {
  final String nama;
  final int id;

  TemanBicara({
    required this.nama,
    required this.id,
  });

  factory TemanBicara.fromJson(Map<String, dynamic> json) {
    return TemanBicara(
      nama: json['nama'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}