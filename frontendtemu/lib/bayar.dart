class PembayaranPerusahaan {
  String? idRekeningPerusahaan;
  String? idAcara;
  int? biayaTotal;
  DateTime? tanggalPembayaran;
  String? buktiPembayaran;

  // Constructor
  PembayaranPerusahaan({
    this.idRekeningPerusahaan,
    this.idAcara,
    this.biayaTotal,
    this.tanggalPembayaran,
    this.buktiPembayaran,
  });

  // Method untuk mengubah objek menjadi Map (untuk JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_rekeningperusahaan': idRekeningPerusahaan,
      'id_acara': idAcara,
      'biayatotal': biayaTotal,
      'tanggalpembayaran': tanggalPembayaran?.toIso8601String(),
      'buktipembayaran': buktiPembayaran,
    };
  }

  // Method untuk mengubah Map (JSON) menjadi objek
  factory PembayaranPerusahaan.fromJson(Map<String, dynamic> json) {
    return PembayaranPerusahaan(
      idRekeningPerusahaan: json['id_rekeningperusahaan'],
      idAcara: json['id_acara'],
      biayaTotal: json['biayatotal'],
      tanggalPembayaran: json['tanggalpembayaran'] != null
          ? DateTime.parse(json['tanggalpembayaran'])
          : null,
      buktiPembayaran: json['buktipembayaran'],
    );
  }
}

class DetailPembayaran {
  String? idPembayaran;
  String? idRekeningTemu;
  int? biayaSponsor;
  int? biayaLayanan;

  // Constructor
  DetailPembayaran({
    this.idPembayaran,
    this.idRekeningTemu,
    this.biayaSponsor,
    this.biayaLayanan,
  });

  // Method untuk mengubah objek menjadi Map (untuk JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_pembayaran': idPembayaran,
      'id_rekeningtemu': idRekeningTemu,
      'biayasponsor': biayaSponsor,
      'biayalayanan': biayaLayanan,
    };
  }

  // Method untuk mengubah Map (JSON) menjadi objek
  factory DetailPembayaran.fromJson(Map<String, dynamic> json) {
    return DetailPembayaran(
      idPembayaran: json['id_pembayaran'],
      idRekeningTemu: json['id_rekeningtemu'],
      biayaSponsor: json['biayasponsor'],
      biayaLayanan: json['biayalayanan'],
    );
  }
}
