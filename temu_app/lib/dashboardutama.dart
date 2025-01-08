// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'horizontallist.dart'; // Import HorizontalListView
// import 'carouselcard.dart'; // Import CarouselSliderWidget

// class PerusahaanDashboard extends StatefulWidget {
//   const PerusahaanDashboard({super.key});

//   @override
//   _PerusahaanDashboardState createState() => _PerusahaanDashboardState();
// }

// class _PerusahaanDashboardState extends State<PerusahaanDashboard> {
//   List<dynamic> events = [];
//   List<dynamic> carouselData = [];
//   bool isLoading = true;
//   late int currentMonth;

//   @override
//   void initState() {
//     super.initState();
//     currentMonth = DateTime.now().month; // Mendapatkan bulan sekarang
//     fetchData();
//   }

//   // Fungsi untuk mengambil data dari API
//   Future<void> fetchData() async {
//     final url = 'https://api.example.com/events'; // URL untuk data event
//     final carouselUrl =
//         'https://api.example.com/carousel'; // URL untuk data carousel

//     try {
//       // Ambil data untuk events
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           events = json.decode(response.body);
//         });
//       }

//       // Ambil data untuk carousel
//       final carouselResponse = await http.get(Uri.parse(carouselUrl));
//       if (carouselResponse.statusCode == 200) {
//         setState(() {
//           carouselData = json.decode(carouselResponse.body);
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   // Fungsi untuk memfilter event berdasarkan bulan
//   List<dynamic> filterEventsByMonth(List<dynamic> events, int month) {
//     return events.where((event) {
//       DateTime eventDate = DateTime.parse(event[
//           'date']); // Pastikan `event['date']` adalah string tanggal yang bisa diparse
//       return eventDate.month == month;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     // Memfilter events berdasarkan bulan sekarang
//     List<dynamic> filteredEvents = filterEventsByMonth(events, currentMonth);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white10,
//         elevation: 0,
//         toolbarHeight: height * 0.1,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/image/logo.png',
//                   width: 40,
//                   height: 40,
//                   errorBuilder: (context, error, stackTrace) => const Icon(
//                     Icons.error,
//                     color: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   "TEMU",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Tampilan "Hi" dan pesan
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Hi, Astra Group",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14.5,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Yuk, kita lihat event mana yang cocok buat kamu!",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Menampilkan Carousel
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : CarouselSliderWidget(data: carouselData),

//               const SizedBox(height: 30),

//               // Menampilkan Horizontal List (Event bulan sekarang)
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 20),
//                 child: Text(
//                   'Event Bulan Ini',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Horizontallist(data: filteredEvents, filter: 'Current Month'),
//               const SizedBox(height: 20),

//               // Menampilkan Horizontal List (Event Makassar)
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 20),
//                 child: Text(
//                   'Event Makassar',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Horizontallist(data: events, filter: 'Makassar'),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
