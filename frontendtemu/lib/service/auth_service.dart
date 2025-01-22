import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontendtemu/dashboardperusahaan.dart';
import 'package:frontendtemu/dashboardorganisasi.dart';
import 'package:frontendtemu/loginperusahaan.dart'; // Import the login screen to redirect after logout
import 'package:frontendtemu/loginorganisasi.dart'; // Import the login screen to redirect after logout
import 'package:frontendtemu/service/consts.dart';

// Initialize the storage for secure token storage
final storage = FlutterSecureStorage();

const baseURL = hostURL;

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

  Future<bool> logout(BuildContext context) async {
    final url = Uri.parse(apiLogoutUrl);

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer $token"},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body)['data'];
      if (response.statusCode == 200) {
        final level = responseData['level'];

          storage.delete(key: 'auth_token');

          // Redirect to HomeScreen on successful login
          if (level == "perusahaan") {
            Navigator.pushReplacementNamed(context, '/loginperusahaan');
          } else {
            Navigator.pushReplacementNamed(context, '/loginorganisasi');
          }
          return true;
        } else {
          print("No token found in the response");
          throw Exception("Invalid token received from the server");
        }
    } catch (e) {
      print("Error occurred during logout: $e");
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
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.'
      };
    }
  }

  Future<Map<dynamic, dynamic>> updatePerusahaanDanPenanggungJawab({
    required BuildContext context,
    required String namaPerusahaan,
    required String kotaDomisiliPerusahaan,
    required String nomorTeleponPerusahaan,
    required String namaLengkapPenanggungJawab,
    required String tanggalLahirPenanggungJawab,
    required String alamatLengkapPenanggungJawab,
    required String emailPenanggungJawab,
  }) async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Update data perusahaan
      final perusahaanResponse = await http.put(
        Uri.parse('$baseURL/perusahaan'), // Endpoint update perusahaan
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'namaperusahaan': namaPerusahaan,
          'kotadomisiliperusahaan': kotaDomisiliPerusahaan,
          'nomorteleponperusahaan': nomorTeleponPerusahaan,
        }),
      );

      print("Perusahaan Response status: ${perusahaanResponse.statusCode}");
      print("Perusahaan Response body: ${perusahaanResponse.body}");

      if (perusahaanResponse.statusCode != 200) {
        return {
          'success': false,
          'message': 'Gagal mengupdate data perusahaan.',
        };
      }

      // Update data penanggung jawab
      final penanggungJawabResponse = await http.put(
        Uri.parse('$baseURL/penanggungjawabperusahaan'), // Endpoint update penanggung jawab
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'namaLengkapPenanggungJawab': namaLengkapPenanggungJawab,
          'tanggalLahirPenanggungJawab': tanggalLahirPenanggungJawab,
          'alamatLengkapPenanggungJawab': alamatLengkapPenanggungJawab,
          'emailPenanggungJawab': emailPenanggungJawab,
        }),
      );

      print("Penanggung Jawab Response status: ${penanggungJawabResponse.statusCode}");
      print("Penanggung Jawab Response body: ${penanggungJawabResponse.body}");

      if (penanggungJawabResponse.statusCode != 200) {
        return {
          'success': false,
          'message': 'Gagal mengupdate data penanggung jawab.',
        };
      }

      // Jika kedua request berhasil
      return {
        'success': true,
        'message': 'Data perusahaan dan penanggung jawab berhasil diupdate.',
      };
    } catch (e) {
      print("Error occurred during update: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.',
      };
    }
  }

  Future<Map<dynamic, dynamic>> updateOrganisasiDanPenanggungJawab({
    required BuildContext context,
    required String namaOrganisasi,
    required String kotaDomisiliOrganisasi,
    required String nomorTeleponOrganisasi,
    required String namaLengkapPenanggungJawab,
    required String tanggalLahirPenanggungJawab,
    required String alamatLengkapPenanggungJawab,
    required String emailPenanggungJawab,
  }) async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Update data organisasi
      final organisasiResponse = await http.put(
        Uri.parse('$baseURL/organisasi'), // Endpoint update organisasi
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'namaorganisasi': namaOrganisasi,
          'kotadomisiliorganisasi': kotaDomisiliOrganisasi,
          'nomorteleponorganisasi': nomorTeleponOrganisasi,
        }),
      );

      print("Organisasi Response status: ${organisasiResponse.statusCode}");
      print("Organisasi Response body: ${organisasiResponse.body}");

      if (organisasiResponse.statusCode != 200) {
        return {
          'success': false,
          'message': 'Gagal mengupdate data organisasi.',
        };
      }

      // Update data penanggung jawab
      final penanggungJawabResponse = await http.put(
        Uri.parse('$baseURL/penanggungjawaborganisasi'), // Endpoint update penanggung jawab
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'namaLengkapPenanggungJawab': namaLengkapPenanggungJawab,
          'tanggalLahirPenanggungJawab': tanggalLahirPenanggungJawab,
          'alamatLengkapPenanggungJawab': alamatLengkapPenanggungJawab,
          'emailPenanggungJawab': emailPenanggungJawab,
        }),
      );

      print("Penanggung Jawab Response status: ${penanggungJawabResponse.statusCode}");
      print("Penanggung Jawab Response body: ${penanggungJawabResponse.body}");

      if (penanggungJawabResponse.statusCode != 200) {
        return {
          'success': false,
          'message': 'Gagal mengupdate data penanggung jawab.',
        };
      }

      // Jika kedua request berhasil
      return {
        'success': true,
        'message': 'Data organisasi dan penanggung jawab berhasil diupdate.',
      };
    } catch (e) {
      print("Error occurred during update: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Periksa koneksi Anda.',
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

}
