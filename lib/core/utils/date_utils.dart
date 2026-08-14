import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd', 'ar');
    return formatter.format(date);
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String relativeDate(DateTime date) {
    final today = DateTime.now();
    final diff = date.difference(today).inDays;

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'اليوم';
    }
    if (diff == -1) return 'أمس';
    if (diff == 1) return 'غداً';
    if (diff < 0) return 'منذ ${-diff} أيام';
    if (diff < 7) return 'بعد $diff أيام';
    return formatDate(date);
  }

  static String weekDayName(DateTime date) {
    final formatter = DateFormat('EEEE', 'ar');
    return formatter.format(date);
  }

  /// The most recent Sunday on or before today (weeks in this app start on
  /// Sunday). `DateTime.weekday` is Monday=1..Sunday=7, so `weekday % 7`
  /// gives days-since-last-Sunday directly (Sunday itself -> 0).
  ///
  /// Was previously `day - (weekday - DateTime.sunday)`, i.e. `day - weekday
  /// + 7` — that computes the *next* Sunday, not the current week's start
  /// (e.g. on a Wednesday it lands 4 days in the future). Never had a
  /// caller before item 3.6's weekly calendar screen, so the bug was never
  /// exercised until now — found and fixed in the same change that adds
  /// the first real usage.
  static DateTime get weekStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - (now.weekday % 7));
  }

  static DateTime get weekEnd => weekStart.add(const Duration(days: 7));
}
