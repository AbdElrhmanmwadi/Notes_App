import 'package:flutter/material.dart';

class Alarm {
  final TimeOfDay time;
  bool isActive;

  Alarm({
    required this.time,
    this.isActive = true,
  });

  String formattedTime() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
