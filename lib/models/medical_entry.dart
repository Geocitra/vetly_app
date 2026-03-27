import 'package:flutter/material.dart';

class MedicalEntry {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String date;

  MedicalEntry({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.date,
  });
}
