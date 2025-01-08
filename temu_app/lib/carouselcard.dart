import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatelessWidget {
  final List<dynamic> data;

  const CarouselSliderWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Sesuaikan dengan kebutuhan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          return Container(
            margin: EdgeInsets.all(8),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item['title'] ?? 'No Title',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
