import 'package:flutter/material.dart';

class StatMetricModel {
  final String title;
  final num value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? trend; // e.g. '+12%'
  final bool isPositive;

  const StatMetricModel({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositive = true,
  });
}
