import 'package:intl/intl.dart';

/// ─────────────────────────────────────────────────────────────
/// Formatting helpers for dates, numbers, currencies, etc.
/// ─────────────────────────────────────────────────────────────
class Formatters {
  Formatters._();

  // ── Date ──

  /// e.g. "25 Feb 2026"
  static String date(DateTime dt, {String locale = 'en'}) {
    return DateFormat('dd MMM yyyy', locale).format(dt);
  }

  /// e.g. "25/02/2026"
  static String dateSlash(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  /// e.g. "Feb 25, 2026 – 12:05 PM"
  static String dateTime(DateTime dt, {String locale = 'en'}) {
    return DateFormat('MMM dd, yyyy – hh:mm a', locale).format(dt);
  }

  /// e.g. "12:05 PM"
  static String time(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  /// e.g. "قبل 5 دقائق" — relative time
  static String timeAgo(DateTime dt, {String locale = 'en'}) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return locale == 'ar' ? 'الآن' : 'Just now';
    if (diff.inMinutes < 60) {
      return locale == 'ar'
          ? 'قبل ${diff.inMinutes} دقيقة'
          : '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return locale == 'ar'
          ? 'قبل ${diff.inHours} ساعة'
          : '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return locale == 'ar' ? 'قبل ${diff.inDays} يوم' : '${diff.inDays}d ago';
    }
    return date(dt, locale: locale);
  }

  // ── Number ──

  /// e.g. "1,234"
  static String number(num value) {
    return NumberFormat('#,##0').format(value);
  }

  /// e.g. "1,234.56"
  static String decimal(num value, {int decimals = 2}) {
    return NumberFormat('#,##0.${'0' * decimals}').format(value);
  }

  /// e.g. "1.2K", "3.5M"
  static String compact(num value) {
    return NumberFormat.compact().format(value);
  }

  // ── Currency ──

  /// e.g. "1,234 IQD"
  static String currency(num value, {String symbol = 'IQD'}) {
    return '${number(value)} $symbol';
  }

  /// e.g. "$1,234.56"
  static String currencySymbol(num value, {String symbol = r'$'}) {
    return '$symbol${decimal(value)}';
  }

  // ── Phone ──

  /// Formats national phone: "07701234567" → "0770 123 4567"
  static String phone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 11) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return raw;
  }

  // ── Distance ──

  /// e.g. "2.5 km" or "800 m"
  static String distance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.round()} m';
  }

  // ── Duration ──

  /// e.g. "1 h 25 min" or "45 min"
  static String duration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours} h ${d.inMinutes.remainder(60)} min';
    }
    return '${d.inMinutes} min';
  }
}
