extension DateExtension on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }
}
