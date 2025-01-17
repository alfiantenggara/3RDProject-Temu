class DetailPembayaran {
  String? idPembayaran;
  String? idRekeningTemu;
  int? biayaSponsor;
  int? biayaLayanan;
  DateTime? tanggalPembayaran;

  // Constructor
  DetailPembayaran({
    this.idPembayaran,
    this.idRekeningTemu,
    this.biayaSponsor,
    this.biayaLayanan,
    this.tanggalPembayaran,
  });

  // Method untuk mengubah objek menjadi Map (untuk JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_pembayaran': idPembayaran,
      'id_rekeningtemu': idRekeningTemu,
      'biayasponsor': biayaSponsor,
      'biayalayanan': biayaLayanan,
      'tanggalpembayaran': tanggalPembayaran?.toIso8601String(),
    };
  }

  // Method untuk mengubah Map (JSON) menjadi objek
  factory DetailPembayaran.fromJson(Map<String, dynamic> json) {
    return DetailPembayaran(
      idPembayaran: json['id_pembayaran'],
      idRekeningTemu: json['id_rekeningtemu'],
      biayaSponsor: json['biayasponsor'],
      biayaLayanan: json['biayalayanan'],
      tanggalPembayaran: json['tanggalpembayaran'] != null
          ? DateTime.parse(json['tanggalpembayaran'])
          : null,
    );
  }
}
