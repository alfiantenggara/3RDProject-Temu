import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardperusahaan.dart';
import 'package:frontendtemu/dashboardorganisasi.dart';
import 'package:frontendtemu/loginperusahaan.dart'; // Import the login screen to redirect after logout
import 'package:frontendtemu/loginorganisasi.dart'; // Import the login screen to redirect after logout

// Initialize the storage for secure token storage
final storage = FlutterSecureStorage();

const host = '127.0.0.1';
const port = '8000';
const baseURL = 'http://' + host + ':' + port + '/api';

// API endpoint URLs
const String apiLoginUrl = baseURL + '/login';
const String apiLogoutUrl = baseURL + '/logout';

class AuthService {
  // Login function
  Future<bool> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(apiLoginUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        final token = responseData['token'];
        final userName = responseData['level'] == "perusahaan"
            ? responseData['namaperusahaan']
            : responseData['namaorganisasi'];

        if (token != null) {
          // Save token securely
          await storage.write(key: 'auth_token', value: token);
          await storage.write(key: 'user_name', value: userName);
          print("Token saved successfully: $token");

          // Redirect to HomeScreen on successful login
          if (responseData['level'] == "perusahaan") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPerusahaan()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardOrganisasi()),
            );
          }
          return true;
        } else {
          print("No token found in the response");
          throw Exception("Invalid token received from the server");
        }
      } else {
        final errorMessage = responseData ?? 'Unknown error';
        print('Failed to login, message: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print("Error occurred during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
    }
    return false;
  }

  Future<String> getSession(BuildContext context) async {
    final url = Uri.parse(baseURL + '/getSession');

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        if (token != null) {
          print("Token: $token");
          print("Registered For : ${responseData['level']}");
          return responseData['level'];
        } else {
          print("No token found in the response");
          throw Exception("Invalid token received from the server");
        }
      } else {
        storage.delete(key: 'auth_token');
        return "None";
      }
    } catch (e) {
      print("Error occurred during get session: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      storage.delete(key: 'auth_token');
      return "None";
    }
  }

  Future<Map<dynamic, dynamic>> getUserData(BuildContext context) async {
    final url = Uri.parse(baseURL + '/user');

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
            'data': responseData['data']['user']
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
      print("Error occurred during get user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  // Register function
  Future<Map<dynamic, dynamic>> register_perusahaan(
      String email,
      String namaPerusahaan,
      String kotaDomisiliPerusahaan,
      String namaLengkapPenanggungJawab,
      String tanggalLahirPenanggungJawab,
      String alamatLengkapPenanggungJawab,
      String nomorTeleponPerusahaan,
      String emailPenanggungJawab,
      String password,
      String ktpBase64,
      BuildContext context) async {
    final url = Uri.parse(baseURL + '/register_perusahaan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'namaPerusahaan': namaPerusahaan,
          'kotaDomisiliPerusahaan': kotaDomisiliPerusahaan,
          'namaLengkapPenanggungJawab': namaLengkapPenanggungJawab,
          'tanggalLahirPenanggungJawab': tanggalLahirPenanggungJawab,
          'alamatLengkapPenanggungJawab': alamatLengkapPenanggungJawab,
          'nomorTeleponPerusahaan': nomorTeleponPerusahaan,
          'emailPenanggungJawab': emailPenanggungJawab,
          'password': password,
          'ktpPenanggungJawab': ktpBase64
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle response and return data
      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPerusahaan()),
          (route) => false,
        );
        return {
          'success': true,
          'message': responseData['message'] ?? '',
        };
      } else {
        print('Failed to register, message: ' + responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred, please try again')),
        );
        return {'success': false, 'message': 'Terjadi kesalahan pada server'};
      }
    } catch (e) {
      print("Error occurred during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  Future<Map<String, dynamic>> register_organisasi(
      String email,
      String namaOrganisasi,
      String kotaDomisiliOrganisasi,
      String namaLengkapPenanggungJawab,
      String tanggalLahirPenanggungJawab,
      String alamatLengkapPenanggungJawab,
      String nomorTeleponOrganisasi,
      String emailPenanggungJawab,
      String password,
      String ktpBase64,
      BuildContext context) async {
    final url = Uri.parse(baseURL + '/register_organisasi');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'namaOrganisasi': namaOrganisasi,
          'kotaDomisiliOrganisasi': kotaDomisiliOrganisasi,
          'namaLengkapPenanggungJawab': namaLengkapPenanggungJawab,
          'tanggalLahirPenanggungJawab': tanggalLahirPenanggungJawab,
          'alamatLengkapPenanggungJawab': alamatLengkapPenanggungJawab,
          'nomorTeleponOrganisasi': nomorTeleponOrganisasi,
          'emailPenanggungJawab': emailPenanggungJawab,
          'password': password,
          'ktpPenanggungJawab': ktpBase64
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle response and return data
      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginOrganisasi()),
          (route) => false,
        );
        return {
          'success': true,
          'message': responseData['message'] ?? '',
        };
      } else {
        print('Failed to register, message: ' + responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred, please try again')),
        );
        return {'success': false, 'message': 'Terjadi kesalahan pada server'};
      }
    } catch (e) {
      print("Error occurred during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  // Logout function
  Future<void> logout(BuildContext parentContext) async {
    try {
      // Revoke token logic (API call)
      final token = await storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse(baseURL + '/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        // Clear stored token
        await storage.delete(key: 'auth_token');

        // Show snackbar on the parent context
        ScaffoldMessenger.of(parentContext).showSnackBar(
          const SnackBar(content: Text('Logout successful')),
        );

        // Navigate to the login screen
        if (responseData['level'] == 'organisasi') {
          Navigator.pushAndRemoveUntil(
            parentContext,
            MaterialPageRoute(builder: (context) => LoginOrganisasi()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            parentContext,
            MaterialPageRoute(builder: (context) => LoginPerusahaan()),
            (route) => false,
          );
        }
      } else {
        print('Failed to logout, message: ' + responseData);
        ScaffoldMessenger.of(parentContext).showSnackBar(
          const SnackBar(content: Text('An error occurred, please try again')),
        );
      }
    } catch (e) {
      // Error handling
      print("Error occurred during registration: $e");
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('An error occurred during logout')),
      );
    }
  }
}
