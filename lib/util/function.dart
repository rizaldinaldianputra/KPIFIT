import 'package:flutter/material.dart';

String greetingMessage() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return 'Selamat Pagi';
  } else if (hour >= 12 && hour < 15) {
    return 'Selamat Siang';
  } else if (hour >= 15 && hour < 18) {
    return 'Selamat Sore';
  } else {
    return 'Selamat Malam';
  }
}

IconData getGreetingIcon() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return Icons.wb_sunny; // Pagi
  } else if (hour >= 12 && hour < 15) {
    return Icons.wb_sunny_outlined; // Siang
  } else if (hour >= 15 && hour < 18) {
    return Icons.wb_twighlight; // Sore
  } else {
    return Icons.nightlight_round; // Malam
  }
}

Color getGreetingColor() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return Colors.orange; // Pagi
  } else if (hour >= 12 && hour < 15) {
    return Colors.yellow; // Siang
  } else if (hour >= 15 && hour < 18) {
    return Colors.deepOrange; // Sore
  } else {
    return Colors.blueGrey; // Malam
  }
}
