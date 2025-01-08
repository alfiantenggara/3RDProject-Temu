import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:temu_app/model/acara.dart'; // Sesuaikan dengan path model yang benar

// Fetch acara data
Future<List<Acara>> fetchAcara() async {
  final response = await http.get(Uri.parse('https://api.example.com/acara'));

  if (response.statusCode == 200) {
    // Mengubah data JSON menjadi list objek Acara
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Acara.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load acara');
  }
}

// Fetch detail waktu acara berdasarkan ID acara
Future<List<DetailWaktuAcara>> fetchDetailWaktuAcara(int idAcara) async {
  final response = await http
      .get(Uri.parse('https://api.example.com/detailwaktuacara/$idAcara'));

  if (response.statusCode == 200) {
    // Mengubah data JSON menjadi list objek DetailWaktuAcara
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => DetailWaktuAcara.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load detail waktu acara');
  }
}
