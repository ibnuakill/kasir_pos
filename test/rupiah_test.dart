import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/core/rupiah.dart';

void main() {
  test('rupiah tampil tanpa desimal dan berpemisah titik', () {
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(500), 'Rp500');
    expect(formatRupiah(1500), 'Rp1.500');
    expect(formatRupiah(15000), 'Rp15.000');
    expect(formatRupiah(1500000), 'Rp1.500.000');
  });

  test('tulisan kasir dibaca kembali jadi angka rupiah', () {
    expect(parseRupiah('15000'), 15000);
    expect(parseRupiah('15.000'), 15000);
    expect(parseRupiah('Rp 15.000'), 15000);
    expect(parseRupiah(''), isNull);
    expect(parseRupiah('abc'), isNull);
  });

  test('angka yang diformat lalu dibaca lagi tidak berubah', () {
    for (final nilai in [0, 7, 999, 1000, 12345, 999999]) {
      expect(parseRupiah(formatRupiah(nilai)), nilai);
    }
  });
}
