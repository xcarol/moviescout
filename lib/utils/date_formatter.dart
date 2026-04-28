import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(BuildContext context, String dateString) {
    if (dateString.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMd(locale).format(date);
    } catch (e) {
      return dateString;
    }
  }
}
