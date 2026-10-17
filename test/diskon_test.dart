import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/core/diskon.dart';

void main() {
  group('hitungPotongan', () {
    test('tanpa Diskon, potongan nol dan Total sama dengan Subtotal', () {
      expect(hitungPotongan(20000, null), 0);
      expect(hitungTotal(20000, null), 20000);
    });

    test('Diskon nominal dipakai apa adanya', () {
      const diskon = Diskon(jenis: JenisDiskon.nominal, nilai: 5000);
      expect(hitungPotongan(20000, diskon), 5000);
      expect(hitungTotal(20000, diskon), 15000);
    });

    test('Diskon persen dihitung dari Subtotal', () {
      const diskon = Diskon(jenis: JenisDiskon.persen, nilai: 10);
      expect(hitungPotongan(15500, diskon), 1550);
      expect(hitungTotal(15500, diskon), 13950);
    });

    test('Diskon persen dibulatkan ke rupiah terdekat', () {
      // 10% dari 1.555 = 155,5 → 156.
      const diskon = Diskon(jenis: JenisDiskon.persen, nilai: 10);
      expect(hitungPotongan(1555, diskon), 156);
      // 10% dari 1.554 = 155,4 → 155.
      expect(hitungPotongan(1554, diskon), 155);
    });

    test('Diskon melebihi Subtotal dijepit, Total jadi nol bukan minus', () {
      const diskon = Diskon(jenis: JenisDiskon.nominal, nilai: 99999);
      expect(hitungPotongan(20000, diskon), 20000);
      expect(hitungTotal(20000, diskon), 0);
    });

    test('Diskon seratus persen menghabiskan Subtotal', () {
      const diskon = Diskon(jenis: JenisDiskon.persen, nilai: 100);
      expect(hitungTotal(20000, diskon), 0);
    });

    test('Keranjang kosong tidak menghasilkan potongan', () {
      const diskon = Diskon(jenis: JenisDiskon.persen, nilai: 10);
      expect(hitungPotongan(0, diskon), 0);
      expect(hitungTotal(0, diskon), 0);
    });
  });

  group('formatDiskon', () {
    test('nominal ditulis sebagai rupiah, persen dengan tanda persen', () {
      expect(
        formatDiskon(const Diskon(jenis: JenisDiskon.nominal, nilai: 5000)),
        'Rp5.000',
      );
      expect(
        formatDiskon(const Diskon(jenis: JenisDiskon.persen, nilai: 10)),
        '10%',
      );
    });
  });

  group('validasiDiskon', () {
    test('isian kosong ditolak', () {
      expect(validasiDiskon('', jenis: JenisDiskon.nominal), 'Diskon wajib diisi');
      expect(validasiDiskon(null, jenis: JenisDiskon.persen), 'Diskon wajib diisi');
    });

    test('nominal menerima tulisan yang masih bertitik', () {
      expect(validasiDiskon('5.000', jenis: JenisDiskon.nominal), isNull);
    });

    test('persen di atas seratus ditolak', () {
      expect(
        validasiDiskon('101', jenis: JenisDiskon.persen),
        'Persen paling banyak 100',
      );
      expect(validasiDiskon('100', jenis: JenisDiskon.persen), isNull);
    });
  });
}
