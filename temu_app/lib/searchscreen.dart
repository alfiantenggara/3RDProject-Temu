import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Filter kategori
  final List<String> costFilters = [
    'Gratis',
    '< Rp 1.000.000',
    'Rp 1.000.000 - Rp 2.000.000',
    'Rp 2.000.000 - Rp 5.000.000',
    'Rp 5.000.000 - Rp 10.000.000'
  ];
  final List<String> locationFilters = [
    'Jakarta',
    'Bandung',
    'Surakarta',
    'Medan',
    'Makassar',
    'Bali',
    'Pangkal Pinang'
  ];
  final List<String> activityFilters = ['Gunung', 'Sungai', 'Laut', 'Lembah'];

  // Status filter
  final Map<String, bool> selectedCosts = {};
  final Map<String, bool> selectedLocations = {};
  final Map<String, bool> selectedActivities = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi filter sebagai tidak aktif
    for (var filter in activityFilters) {
      selectedActivities[filter] = false;
    }
    for (var filter in locationFilters) {
      selectedLocations[filter] = false;
    }
    for (var filter in costFilters) {
      selectedCosts[filter] = false;
    }
  }

  // Utility untuk membangun daftar FilterChip
  Widget buildFilterChipList(
      Map<String, bool> filterMap, StateSetter setStateDialog) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: filterMap.keys.map((filter) {
        return FilterChip(
          label: Text(filter),
          selected: filterMap[filter] ?? false,
          selectedColor: Colors.blue,
          checkmarkColor: Colors.white,
          onSelected: (bool isSelected) {
            setStateDialog(() {
              filterMap[filter] = isSelected;
            });
            setState(() {
              filterMap[filter] = isSelected;
            });
          },
        );
      }).toList(),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text("Pilih Filter"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Berdasarkan Biaya",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildFilterChipList(selectedCosts, setStateDialog),
                    const SizedBox(height: 16),
                    const Text("Berdasakan Lokasi",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildFilterChipList(selectedLocations, setStateDialog),
                    const SizedBox(height: 16),
                    const Text("Berdasarkan Kegiatan",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildFilterChipList(selectedActivities, setStateDialog),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            null, // Kosongkan title karena kita akan menambahkan custom title di flexibleSpace
        centerTitle: false, // Nonaktifkan pengaturan centerTitle default
        flexibleSpace: const Center(
          // Gunakan Center untuk menempatkan teks di tengah
          child: Text(
            "Event ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cari Event...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 10,
                            spreadRadius: 3,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.filter_alt, size: 25),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  ...selectedActivities.entries
                      .where((entry) => entry.value)
                      .map((entry) => FilterChip(
                            label: Text(entry.key),
                            selected: entry.value,
                            selectedColor: Colors.blue,
                            checkmarkColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                selectedActivities[entry.key] = isSelected;
                              });
                            },
                          )),
                  ...selectedLocations.entries
                      .where((entry) => entry.value)
                      .map((entry) => FilterChip(
                            label: Text(entry.key),
                            selected: entry.value,
                            selectedColor: Colors.blue,
                            checkmarkColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                selectedLocations[entry.key] = isSelected;
                              });
                            },
                          )),
                  ...selectedCosts.entries
                      .where((entry) => entry.value)
                      .map((entry) => FilterChip(
                            label: Text(entry.key),
                            selected: entry.value,
                            selectedColor: Colors.blue,
                            checkmarkColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                selectedCosts[entry.key] = isSelected;
                              });
                            },
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
