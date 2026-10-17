import 'kuantitas.dart';

/// Uang di seluruh aplikasi adalah bilangan bulat rupiah, jadi tidak ada
/// pembulatan di mana pun: hanya tampilan yang diberi titik ribuan.
String formatRupiah(int nilai) {
  final digit = nilai.abs().toString();
  final buf = StringBuffer();

  for (var i = 0; i < digit.length; i++) {
    if (i > 0 && (digit.length - i) % 3 == 0) buf.write('.');
    buf.write(digit[i]);
  }

  return '${nilai < 0 ? '-' : ''}Rp$buf';
}

/// Membaca kembali tulisan kasir, termasuk yang masih membawa titik atau "Rp".
/// Mengembalikan null bila tidak ada angka sama sekali.
int? parseRupiah(String teks) {
  final digit = teks.replaceAll(RegExp(r'[^0-9]'), '');
  if (digit.isEmpty) return null;
  return int.tryParse(digit);
}

/// Harga satu baris: harga satuan × Kuantitas, dibulatkan ke rupiah terdekat
/// karena uang di aplikasi ini tidak punya pecahan.
///
/// Dipakai bersama oleh Keranjang dan oleh Transaksi yang disimpan, supaya
/// angka di layar dan angka di database tidak pernah beda satu rupiah.
int hitungSubtotalBaris(int hargaSatuan, int kuantitasMili) =>
    (hargaSatuan * kuantitasMili + skalaKuantitas ~/ 2) ~/ skalaKuantitas;
