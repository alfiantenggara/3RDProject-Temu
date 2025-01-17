import 'package:flutter/material.dart';
import 'package:temu_app/model/acara.dart';
import 'package:intl/intl.dart';
import 'package:temu_app/pages/beriuang.dart';

class DetailPageAcara extends StatefulWidget {
  final Acara acara;

  const DetailPageAcara({Key? key, required this.acara}) : super(key: key);

  @override
  State<DetailPageAcara> createState() => DetailPageAcaraState();
}

class DetailPageAcaraState extends State<DetailPageAcara> {
  late Acara acara;
  bool isFavorited = false;
  bool isShared = false;

  @override
  void initState() {
    super.initState();
    acara = widget.acara;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = acara.tanggalAcara != null
        ? DateFormat('dd MMM yyyy').format(acara.tanggalAcara!)
        : 'Tanggal tidak tersedia';

    String waktuMulai = acara.detailWaktu?.isNotEmpty == true
        ? acara.detailWaktu![0].formatWaktu(acara.detailWaktu![0].waktuMulai)
        : 'Tidak tersedia';

    String waktuSelesai = acara.detailWaktu?.isNotEmpty == true
        ? acara.detailWaktu![0].formatWaktu(acara.detailWaktu![0].waktuSelesai)
        : 'Tidak tersedia';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image and flexible space
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: acara.gambarAcara ??
                            'https://via.placeholder.com/600x400',
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    // Your image or background content
                    Positioned.fill(
                      child: Image.network(
                        acara.gambarAcara ??
                            'https://via.placeholder.com/600x400',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Action buttons positioned at the top right
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorited ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorited =
                                    !isFavorited; // Toggle state favorit
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isShared ? Icons.share : Icons.share_outlined,
                              color: isShared ? Colors.blue : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isShared = !isShared; // Toggle state share
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SliverFillRemaining to push the content to the top and leave space for the button
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius:
                      BorderRadius.circular(16), // Circular border radius
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10, // Blur radius for the shadow
                      offset: Offset(0, 4), // Position of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        acara.namaAcara ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            acara.kotaBerlangsung ?? 'Lokasi tidak tersedia',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jam: $waktuMulai - $waktuSelesai',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Biaya Acara',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(acara.biayaDibutuhkan),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tentang Acara',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deskripsi tidak tersedia.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lokasi Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        acara.lokasiAcara ?? 'Lokasi tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Kegiatan Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        acara.kegiatanAcara ?? 'Kegiatan tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Proposal Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (acara.proposalFile != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                acara.proposalFile!.endsWith('.pdf')
                                    ? Icons.picture_as_pdf
                                    : Icons.insert_drive_file,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              'Proposal Event.${acara.proposalFile!.split('.').last}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text('Tap untuk membuka file'),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () {
                              // Implement file opening logic here
                            },
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Proposal tidak tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Chat
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 60), // Tentukan tinggi tombol
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Tombol Sumbang Sekarang
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: 60), // Tentukan tinggi tombol
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeriUangPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sumbang Sekarang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
