import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/core/kuantitas.dart';

void main() {
  test('kuantitas tampil dengan koma dan tanpa nol berekor', () {
    expect(formatKuantitas(0), '0');
    expect(formatKuantitas(1000), '1');
    expect(formatKuantitas(10000), '10');
    expect(formatKuantitas(2500), '2,5');
    expect(formatKuantitas(1250), '1,25');
    expect(formatKuantitas(1005), '1,005');
  });

  test('tulisan kasir dibaca jadi kuantitas berskala seribu', () {
    expect(parseKuantitas('10'), 10000);
    expect(parseKuantitas('2,5'), 2500);
    expect(parseKuantitas('2.5'), 2500);
    expect(parseKuantitas('0,75'), 750);
    expect(parseKuantitas(''), isNull);
    expect(parseKuantitas('dua'), isNull);
  });

  test('lebih dari tiga angka desimal ditolak', () {
    expect(parseKuantitas('1,2345'), isNull);
  });

  test('yang diformat lalu dibaca lagi tidak berubah', () {
    for (final nilai in [0, 1000, 2500, 1005, 999999]) {
      expect(parseKuantitas(formatKuantitas(nilai)), nilai);
    }
  });
}
