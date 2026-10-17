/// Tanggal dan jam dalam bentuk yang dibaca kasir: 17/10/2026 09:30.
String formatWaktu(DateTime waktu) {
  String dua(int angka) => angka.toString().padLeft(2, '0');
  return '${dua(waktu.day)}/${dua(waktu.month)}/${waktu.year} '
      '${dua(waktu.hour)}:${dua(waktu.minute)}';
}
