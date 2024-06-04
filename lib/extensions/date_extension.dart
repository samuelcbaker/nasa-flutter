import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  String format() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}

extension StringDateExtension on String {
  DateTime? toDate() {
    return DateFormat('yyyy-MM-dd').tryParse(this);
  }
}
