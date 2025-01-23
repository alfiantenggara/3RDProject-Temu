import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontendtemu/service/consts.dart';

// Initialize the storage for secure token storage
final storage = FlutterSecureStorage();

const baseURL = hostURL + '/acara';

class AcaraService {
  Future<Map<dynamic, dynamic>> getAllAcara(BuildContext context) async {
    final url = Uri.parse(baseURL + '/getIncoming');

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
      print("Error occurred during get Acara: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  Future<Map<dynamic, dynamic>> getById(String id, BuildContext context) async {
    final url = Uri.parse(baseURL + '/' + id);

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });

      print("Fetching acara with id: $id");

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
      print("Error occurred during get Acara: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  Future<Map<dynamic, dynamic>> searchAcara(String keyword, BuildContext context) async {
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
