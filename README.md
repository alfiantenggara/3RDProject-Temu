# TEMU - Aplikasi Frontend Flutter

TEMU adalah aplikasi mobile berbasis Flutter yang bertujuan untuk mempermudah kemitraan antara organisasi non-profit dan perusahaan agar lebih mudah dan terpercaya. Aplikasi ini berfungsi sebagai antarmuka pengguna yang berkomunikasi dengan backend Laravel.

## 📌 Teknologi yang Digunakan
- Flutter (Frontend)
- Dart
- Laravel (Backend)

## 📂 Struktur Proyek
```
frontendtemu/
│-- android/
│-- ios/
│-- lib/
│   │-- chatOrganisasi/
│   │-- chatPerusahaan/
│   │-- service/
│   │-- other-screens...
│-- assets/
│-- pubspec.yaml
│-- README.md
```

## 🚀 Instalasi dan Menjalankan Proyek

### 1. Clone Repository
```bash
git clone https://github.com/alfiantenggara/3RDProject-Temu.git
cd 3RDProject-Temu/frontendtemu
```

### 2. Instalasi Dependensi
```bash
flutter pub get
```

### 3. Jalankan Aplikasi
```bash
flutter run
```
Pastikan emulator atau perangkat terhubung.

## 🔗 Koneksi ke Backend
Aplikasi ini terhubung dengan backend Laravel yang dapat diakses di repository berikut:
[TEMU Backend (Laravel)](https://github.com/leowdij08/ALP-Semester-3-Kelompok-2)

Konfigurasi URL backend dapat diatur di dalam file `lib/services/consts.dart`:
```dart
const host = '192.168.133.147';
const port = '8190';
const hostURL = 'http://' + host + ':' + port + '/api';
```
Ubah `host` dan `port` sesuai dengan alamat server backend yang digunakan.

## 🔗 Fitur Utama
- **Autentikasi Pengguna** (Login & Register untuk perusahaan dan organisasi)
- **Manajemen Acara** (Melihat, mencari, dan membuat acara)
- **Chat** (Berkomunikasi antara organisasi dan perusahaan)
- **Laporan & Pembayaran** (Mengelola laporan dan pembayaran untuk kemitraan)
