import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/nomor_transaksi.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/transaksi_store.dart';

void main() {
  late AppDatabase database;
  late ProdukStore produk;
  late TransaksiStore transaksi;
  late ProdukData kopi;
  late ProdukData beras;

  final pagi = DateTime(2026, 10, 17, 9, 30);

  setUp(() async {
    database = AppDatabase.inMemory();
    produk = ProdukStore(database);
    transaksi = TransaksiStore(database);

    final kopiId = await produk.tambah(
      nama: 'Kopi Bubuk',
      hargaKatalog: 15000,
      satuan: 'pcs',
    );
    final berasId = await produk.tambah(
      nama: 'Beras',
      hargaKatalog: 12000,
      satuan: 'kg',
      bolehPecahan: true,
    );
    kopi = (await produk.cari(kopiId))!;
    beras = (await produk.cari(berasId))!;

    final stok = StokStore(database);
    await stok.tambahStok(kopiId, jumlahMili: 10000, waktu: pagi);
    await stok.tambahStok(berasId, jumlahMili: 5000, waktu: pagi);
  });
  tearDown(() => database.close());

  Future<int> stokMili(int produkId) async {
    final total = database.pergerakanStok.jumlahMili.sum();
    final query = database.selectOnly(database.pergerakanStok)
      ..addColumns([total])
      ..where(database.pergerakanStok.produkId.equals(produkId));
    final baris = await query.getSingle();
    return baris.read(total) ?? 0;
  }

  Future<int> jumlahTransaksi() async {
    final semua = await database.select(database.transaksi).get();
    return semua.length;
  }

  Future<TransaksiData> jualKopi({
    int kuantitasMili = 1000,
    DateTime? waktu,
    int uangDiterima = 20000,
    Diskon? diskon,
    MetodeBayar metode = MetodeBayar.tunai,
  }) {
    return transaksi.simpan(
      waktu: waktu ?? pagi,
      metodeBayar: metode,
      baris: [BarisTerjual(produk: kopi, kuantitasMili: kuantitasMili)],
      diskon: diskon,
      uangDiterima: uangDiterima,
    );
  }

  group('nomor Transaksi', () {
    test('bersusun per hari dan mulai lagi dari satu besoknya', () async {
      final pertama = await jualKopi();
      final kedua = await jualKopi();

      expect(pertama.nomor, 'TRX-20261017-001');
      expect(kedua.nomor, 'TRX-20261017-002');

      final besok = await jualKopi(waktu: DateTime(2026, 10, 18, 8));
      expect(besok.nomor, 'TRX-20261018-001');
    });

    test('format tiga digit dan tanggal dua digit', () {
      expect(formatNomorTransaksi(DateTime(2026, 1, 5), 7), 'TRX-20260105-007');
      expect(urutanNomorTransaksi('TRX-20261017-042'), 42);
      expect(urutanNomorTransaksi('bukan-nomor'), isNull);
    });
  });

  group('simpan Transaksi', () {
    test('Stok berkurang sesuai Kuantitas yang terjual', () async {
      await jualKopi(kuantitasMili: 2500, uangDiterima: 40000);

      expect(await stokMili(kopi.id), 10000 - 2500);
    });

    test('menyimpan nama dan harga Produk saat terjual', () async {
      final hasil = await jualKopi();

      // Harga katalog berubah setelah Transaksi tersimpan.
      await produk.ubah(
        kopi.id,
        nama: 'Kopi Bubuk Premium',
        hargaKatalog: 22000,
        satuan: 'pcs',
        bolehPecahan: false,
      );

      final baris = await transaksi.barisDari(hasil.id);
      expect(baris.single.namaProduk, 'Kopi Bubuk');
      expect(baris.single.hargaSatuan, 15000);
      expect(baris.single.subtotal, 15000);
      expect(baris.single.satuan, 'pcs');
      expect(baris.single.kuantitasMili, 1000);
    });

    test('menghitung Subtotal, Diskon, Total, dan Kembalian', () async {
      final hasil = await jualKopi(
        diskon: const Diskon(jenis: JenisDiskon.persen, nilai: 10),
        uangDiterima: 20000,
      );

      expect(hasil.subtotal, 15000);
      expect(hasil.potongan, 1500);
      expect(hasil.total, 13500);
      expect(hasil.uangDiterima, 20000);
      expect(hasil.kembalian, 6500);
      expect(hasil.metodeBayar, MetodeBayar.tunai);
      expect(hasil.diskonJenis, JenisDiskon.persen);
      expect(hasil.diskonNilai, 10);
    });

    test('QRIS tersimpan tanpa uang diterima dan tanpa Kembalian', () async {
      final hasil = await jualKopi(
        metode: MetodeBayar.qris,
        uangDiterima: 0,
      );

      expect(hasil.total, 15000);
      expect(hasil.uangDiterima, isNull);
      expect(hasil.kembalian, isNull);
    });

    test('uang kurang dari Total menolak pembayaran dan tidak menyimpan apa '
        'pun', () async {
      await expectLater(
        jualKopi(uangDiterima: 10000),
        throwsA(isA<UangKurangException>()),
      );

      expect(await jumlahTransaksi(), 0);
      expect(await stokMili(kopi.id), 10000);
    });

    test('Stok kurang dari Kuantitas menolak Transaksi', () async {
      await expectLater(
        jualKopi(kuantitasMili: 20000, uangDiterima: 400000),
        throwsA(isA<StokKurangException>()),
      );

      expect(await jumlahTransaksi(), 0);
      expect(await stokMili(kopi.id), 10000);
    });

    test('dua baris Produk yang sama dijumlahkan dulu', () async {
      // Masing-masing baris masih di bawah Stok, tapi gabungannya melebihi.
      await expectLater(
        transaksi.simpan(
          waktu: pagi,
          metodeBayar: MetodeBayar.tunai,
          baris: [
            BarisTerjual(produk: kopi, kuantitasMili: 8000),
            BarisTerjual(produk: kopi, kuantitasMili: 8000),
          ],
          uangDiterima: 300000,
        ),
        throwsA(isA<StokKurangException>()),
      );

      expect(await jumlahTransaksi(), 0);
      expect(await stokMili(kopi.id), 10000);
    });

    test('satu Transaksi bisa memuat beberapa Produk', () async {
      final hasil = await transaksi.simpan(
        waktu: pagi,
        metodeBayar: MetodeBayar.tunai,
        baris: [
          BarisTerjual(produk: kopi, kuantitasMili: 1000),
          BarisTerjual(produk: beras, kuantitasMili: 2500),
        ],
        uangDiterima: 50000,
      );

      expect(hasil.subtotal, 15000 + 30000);
      expect(hasil.total, 45000);
      expect(hasil.kembalian, 5000);
      expect((await transaksi.barisDari(hasil.id)).length, 2);
      expect(await stokMili(beras.id), 5000 - 2500);
    });

    test('Transaksi tanpa baris ditolak', () async {
      expect(
        () => transaksi.simpan(
          waktu: pagi,
          metodeBayar: MetodeBayar.tunai,
          baris: const [],
          uangDiterima: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
