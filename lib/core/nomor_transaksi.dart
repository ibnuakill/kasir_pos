/// Nomor Transaksi yang dibuat otomatis: `TRX-<YYYYMMDD>-<NNN>`, urut per hari
/// kalender device. Bagian tanggal memakai waktu lokal Transaksi itu sendiri.
String prefixNomorTransaksi(DateTime waktu) {
  String dua(int angka) => angka.toString().padLeft(2, '0');
  return 'TRX-${waktu.year}${dua(waktu.month)}${dua(waktu.day)}-';
}

/// Urutan ditulis tiga digit supaya nomor tetap sama panjang dan mudah
/// dibacakan lewat telepon: `TRX-20261017-007`.
String formatNomorTransaksi(DateTime waktu, int urutan) =>
    '${prefixNomorTransaksi(waktu)}${urutan.toString().padLeft(3, '0')}';

/// Urutan yang sudah dipakai sebuah nomor, atau null bila bentuknya asing.
int? urutanNomorTransaksi(String nomor) {
  final bagian = nomor.split('-');
  if (bagian.length != 3) return null;
  return int.tryParse(bagian.last);
}
