import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontendtemu/service/consts.dart';

// Initialize the storage for secure token storage
final storage = FlutterSecureStorage();

const baseURL = hostURL + '/perusahaan';

class PerusahaanService {
  Future<Map<dynamic, dynamic>> getAllPerusahaan(BuildContext context) async {
    final url = Uri.parse(baseURL);

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (token != null) {
          return {
            'success': true,
            'message': responseData['message'],
            'data': responseData['data']
          };
        } else {
          print("No token found in the response");
          throw Exception("Invalid token received from the server");
        }
      } else {
        return {
          'success': false,
          'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
        };
      }
    } catch (e) {
      print("Error occurred during get all perusahaan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  Future<Map<dynamic, dynamic>> searchPerusahaan(String keyword, BuildContext context) async {
    final url = Uri.parse(baseURL + '/search/' + keyword);

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (token != null) {
          return {
            'success': true,
            'message': responseData['message'],
            'data': responseData['data']
          };
        } else {
          print("No token found in the response");
          throw Exception("Invalid token received from the server");
        }
      } else {
        return {
          'success': false,
          'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
        };
      }
    } catch (e) {
      print("Error occurred during search: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }
}
