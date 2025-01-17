import 'package:temu_app/model/acara.dart';

List<Acara> dummyData() {
  return [
    Acara(
      idAcara: 1,
      idOrganisasi: 101,
      namaAcara: "Konferensi Teknologi",
      tanggalAcara: DateTime(2025, 1, 15),
      lokasiAcara: "Gedung A, Jakarta",
      biayaDibutuhkan: 50000,
      kegiatanAcara: "Presentasi dan Diskusi",
      kotaBerlangsung: "Jakarta",
      gambarAcara: "assets/image/cutechibi.jpeg",
      detailWaktu: [
        DetailWaktuAcara(
          idDetail: 1,
          idAcara: 1,
          waktuMulai: DateTime(2025, 1, 15, 9, 0),
          waktuSelesai: DateTime(2025, 1, 15, 12, 0),
        ),
      ],
    ),
    Acara(
      idAcara: 2,
      idOrganisasi: 102,
      namaAcara: "Seminar Pendidikan",
      tanggalAcara: DateTime(2025, 2, 20),
      lokasiAcara: "Gedung B, Bandung",
      biayaDibutuhkan: 75000,
      kegiatanAcara: "Gunung",
      kotaBerlangsung: "Bandung",
      gambarAcara: "https://example.com/seminar_pendidikan.png",
      detailWaktu: [
        DetailWaktuAcara(
          idDetail: 2,
          idAcara: 2,
          waktuMulai: DateTime(2025, 2, 20, 10, 0),
          waktuSelesai: DateTime(2025, 2, 20, 14, 0),
        ),
      ],
    ),
    Acara(
      idAcara: 3,
      idOrganisasi: 103,
      namaAcara: "Workshop Desain Grafis",
      tanggalAcara: DateTime(2025, 3, 25),
      lokasiAcara: "Gedung C, Surabaya",
      biayaDibutuhkan: 100000,
      kegiatanAcara: "Belajar Desain dan Diskusi",
      kotaBerlangsung: "Surabaya",
      gambarAcara: "https://example.com/workshop_desain.png",
      detailWaktu: [
        DetailWaktuAcara(
          idDetail: 3,
          idAcara: 3,
          waktuMulai: DateTime(2025, 3, 25, 13, 0),
          waktuSelesai: DateTime(2025, 3, 25, 17, 0),
        ),
      ],
    ),
  ];
}
