/// Format Rupiah: `Rp 199.000` (titik ribuan, tanpa desimal).
/// Prompt 8 menambah edge case & test lengkap; ini versi dasar.
abstract final class CurrencyFormatter {
  static String rupiah(int amount) {
    final negative = amount < 0;
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return '${negative ? '-' : ''}Rp $buffer';
  }
}
