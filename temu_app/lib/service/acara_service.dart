import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/acara.dart'; // Model acara yang sudah didefinisikan sebelumnya

class AcaraService {
  static const apiUrl = "https://api.example.com/acara";
  List<Acara> publishedAcara = [];

  Future<bool> addOrUpdateAcara(dynamic acaraData) async {
    try {
      // Tentukan apakah data berbentuk Map atau objek
      final body = publishedAcara is Map<String, dynamic>
          ? jsonEncode(acaraData)
          : jsonEncode(acaraData.toJson());

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Acara berhasil ditambahkan!");
        return true;
      } else {
        print("Gagal menambahkan acara! ${response.body}");
        return false;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return false;
    }
  }

  Future<void> deleteAcara(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '$apiUrl/$id'), // Asumsikan API Anda menerima endpoint dengan ID
      );
      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus acara dengan ID: $id');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }

  Future<String> fetchIdOrganisasi() async {
    final response =
        await http.get(Uri.parse('https://api.example.com/organisasi'));

    if (response.statusCode == 200) {
      // Misalnya response body adalah JSON yang berisi idOrganisasi
      var data = json.decode(response.body);
      return data['idOrganisasi']; // Ambil idOrganisasi dari response
    } else {
      throw Exception('Failed to load organisasi');
    }
  }

  Future<List<Acara>> getAcarafromApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Acara.fromJson(item)).toList();
      } else {
        throw Exception(
            'Gagal memuat data dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }
}

// Fungsi untuk mengambil acara dari service
