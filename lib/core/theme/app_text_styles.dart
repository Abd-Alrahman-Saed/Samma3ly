import 'package:flutter/material.dart';

class AppTextStyles {
  static const String _fontFamily = 'Cairo';

  static const TextStyle pageHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A),
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A),
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A),
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B),
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: Color(0xFF64748B),
  );

  static const TextStyle muted = TextStyle(
    fontSize: 11,
    color: Color(0xFF94A3B8),
  );

  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle score = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2563EB),
  );

  static const TextStyle infoLabel = TextStyle(
    fontSize: 13,
    color: Color(0xFF64748B),
    fontWeight: FontWeight.w500,
  );

  static const TextStyle infoValue = TextStyle(
    fontSize: 14,
    color: Color(0xFF0F172A),
  );
}
