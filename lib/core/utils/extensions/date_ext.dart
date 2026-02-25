import 'package:intl/intl.dart';

/// ─────────────────────────────────────────────────────────────
/// DateTime extensions.
/// ─────────────────────────────────────────────────────────────
extension DateExt on DateTime {
  /// "25 Feb 2026"
  String get formatted => DateFormat('dd MMM yyyy').format(this);

  /// "25/02/2026"
  String get slashDate => DateFormat('dd/MM/yyyy').format(this);

  /// "12:05 PM"
  String get timeOnly => DateFormat('hh:mm a').format(this);

  /// "Feb 25, 2026 – 12:05 PM"
  String get full => DateFormat('MMM dd, yyyy – hh:mm a').format(this);

  /// ISO 8601 for API: "2026-02-25T12:05:00.000Z"
  String get toApi => toUtc().toIso8601String();

  /// Is the same calendar day?
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Is today?
  bool get isToday => isSameDay(DateTime.now());

  /// Is yesterday?
  bool get isYesterday =>
      isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  /// Is tomorrow?
  bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));

  /// Days difference from now (positive = future, negative = past).
  int get daysFromNow => difference(DateTime.now()).inDays;

  /// Start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Age in years.
  int get age {
    final now = DateTime.now();
    var a = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) a--;
    return a;
  }
}

/// Parse helper for nullable strings.
extension DateParsing on String? {
  DateTime? get toDate {
    if (this == null || this!.isEmpty) return null;
    return DateTime.tryParse(this!);
  }
}
