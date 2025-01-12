import 'package:intl/intl.dart';

class Acara {
  int? idAcara;
  int? idOrganisasi;
  String? namaAcara;
  DateTime? tanggalAcara;
  String? lokasiAcara;
  int? biayaDibutuhkan;
  String? kegiatanAcara;
  String? kotaBerlangsung;
  String? gambarAcara; // Gambar disimpan sebagai String (URL)
  List<DetailWaktuAcara>? detailWaktu;

  Acara({
    this.idAcara,
    this.idOrganisasi,
    this.namaAcara,
    this.tanggalAcara,
    this.lokasiAcara,
    this.biayaDibutuhkan,
    this.kegiatanAcara,
    this.kotaBerlangsung,
    this.gambarAcara,
    this.detailWaktu,
  });

  factory Acara.fromJson(Map<String, dynamic> json) {
    return Acara(
      idAcara: json['id_acara'],
      idOrganisasi: json['id_organisasi'],
      namaAcara: json['namaacara'],
      tanggalAcara: DateTime.parse(json['tanggalacara']),
      lokasiAcara: json['lokasiacara'],
      biayaDibutuhkan: json['biayadibutuhkan'],
      kegiatanAcara: json['kegiatanacara'],
      kotaBerlangsung: json['kotaberlangsung'],
      gambarAcara: json['gambar'], // URL gambar disimpan sebagai String
      detailWaktu: (json['detailWaktu'] as List?)
          ?.map((e) => DetailWaktuAcara.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idAcara, // Pastikan ini sesuai dengan kebutuhan API Anda
      'id_organisasi': idOrganisasi,
      'namaAcara': namaAcara,
      'tanggalacara': tanggalAcara,
      'lokasiacara': lokasiAcara,
      'biayaDibutuhkan': biayaDibutuhkan,
      'kegiatanacara': kegiatanAcara,
      'kotaBerlangsung': kotaBerlangsung,
      'gambar': gambarAcara,
      'detailWaktu':
          detailWaktu?.map((e) => e.toJson()).toList(), // Konversi list ke JSON
    };
  }
}

int getCurrentUserId() {
  // Ganti dengan logika autentikasi untuk mendapatkan ID user
  return 101; // Contoh ID user
}

class DetailWaktuAcara {
  int? idDetail;
  int? idAcara;
  DateTime? waktuMulai;
  DateTime? waktuSelesai;

  DetailWaktuAcara({
    this.idDetail,
    this.idAcara,
    this.waktuMulai,
    this.waktuSelesai,
  });

  factory DetailWaktuAcara.fromJson(Map<String, dynamic> json) {
    return DetailWaktuAcara(
      idDetail: json['id_detail'],
      idAcara: json['id_acara'],
      waktuMulai: DateTime.parse(json['waktumulai']),
      waktuSelesai: DateTime.parse(json['waktuselesai']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_detail': idDetail,
      'id_acara': idAcara,
      'waktumulai': waktuMulai?.toIso8601String(),
      'waktuselesai': waktuSelesai?.toIso8601String(),
    };
  }

  // Format waktu mulai dan selesai acara
  String formatWaktu(DateTime? waktu) {
    if (waktu == null) return "Waktu tidak tersedia";
    final DateFormat formatter = DateFormat('HH:mm'); // Format jam dan menit
    return formatter.format(waktu); // Mengubah DateTime menjadi string
  }

  String formattWaktu(DateTime waktu) {
    final format = DateFormat('yyyy-MM-dd HH:mm');
    return format.format(waktu);
  }
}
