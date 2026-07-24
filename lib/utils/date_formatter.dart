/// Format tanggal singkat Bahasa Indonesia tanpa perlu init locale intl.
abstract final class DateFormatter {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// `20 Jul 2026`.
  static String short(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// Dari epoch ms.
  static String shortMs(int ms) =>
      short(DateTime.fromMillisecondsSinceEpoch(ms));
}
