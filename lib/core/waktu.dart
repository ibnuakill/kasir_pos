/// Tanggal saja: 17/10/2026.
String formatTanggal(DateTime waktu) {
  String dua(int angka) => angka.toString().padLeft(2, '0');
  return '${dua(waktu.day)}/${dua(waktu.month)}/${waktu.year}';
}

/// Jam saja: 09:30.
String formatJam(DateTime waktu) {
  String dua(int angka) => angka.toString().padLeft(2, '0');
  return '${dua(waktu.hour)}:${dua(waktu.minute)}';
}

/// Awal hari kalender perangkat untuk [waktu].
DateTime awalHari(DateTime waktu) =>
    DateTime(waktu.year, waktu.month, waktu.day);

/// Tanggal dan jam dalam bentuk yang dibaca kasir: 17/10/2026 09:30.
String formatWaktu(DateTime waktu) =>
    '${formatTanggal(waktu)} ${formatJam(waktu)}';
