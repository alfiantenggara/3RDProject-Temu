import 'package:flutter/material.dart';
import 'dart:math'; // Untuk random generator

class Counter {
  int value;
  Color color;

  Counter({this.value = 0, required this.color});

  void increment() {
    value++;
  }

  void decrement() {
    if (value > 0) value--;
  }

  void changeColor(Color newColor) {
    color = newColor;
  }
}

class GlobalState {
  final List<Counter> _counters = [];
  final Random _random = Random(); // Inisialisasi random generator

  List<Counter> get counters => _counters;

  void addCounter() {
    // Pilih warna secara siklus dari daftar Colors.primaries
    final newColor = Colors.primaries[_counters.length % Colors.primaries.length];
    _counters.add(Counter(color: newColor));
  }

  void removeCounter(int index) {
    _counters.removeAt(index);
  }

  void incrementCounter(int index) {
    _counters[index].increment();
  }

  void decrementCounter(int index) {
    _counters[index].decrement();
  }

  void changeCounterColor(int index) {
    final currentColor = _counters[index].color;

    // Pilih warna acak yang berbeda dari warna saat ini
    Color newColor;
    do {
      newColor = Colors.primaries[_random.nextInt(Colors.primaries.length)];
    } while (newColor == currentColor);

    _counters[index].changeColor(newColor);
  }

  void reorderCounters(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final counter = _counters.removeAt(oldIndex);
    _counters.insert(newIndex, counter);
  }
}
