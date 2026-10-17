import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';

import 'bantuan.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');
  });
  tearDown(() => database.close());

  Future<void> bukaProduk(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Produk').last);
    await tester.pumpAndSettle();
  }

  Future<void> bukaProdukBernama(WidgetTester tester, String nama) async {
    await tester.tap(find.text(nama));
    await tester.pumpAndSettle();
  }

  Future<void> tambahStok(WidgetTester tester, String jumlah) async {
    await tester.ensureVisible(find.byKey(const Key('stok-tambah')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('stok-tambah')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('stok-jumlah')), jumlah);
    await tester.tap(find.byKey(const Key('stok-simpan')));
    await tester.pumpAndSettle();
  }

  /// Riwayat dicari di dalam daftarnya sendiri: tombol "Tambah Stok" dan
  /// "Koreksi Stok" memakai kata yang sama.
  Finder diRiwayat(String teks) => find.descendant(
    of: find.byKey(const Key('stok-riwayat')),
    matching: find.textContaining(teks),
  );

  Future<void> koreksiStok(WidgetTester tester, String jumlah) async {
    await tester.ensureVisible(find.byKey(const Key('stok-koreksi')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('stok-koreksi')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('stok-koreksi-jumlah')), jumlah);
    await tester.tap(find.byKey(const Key('stok-koreksi-simpan')));
    await tester.pumpAndSettle();
  }

  test('catatan Stok menolak angka yang membuat Stok negatif', () async {
    final id = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    final stok = StokStore(database);
    final waktu = DateTime(2026, 10, 17);

    await expectLater(
      stok.tambahStok(id, jumlahMili: -1000, waktu: waktu),
      throwsArgumentError,
    );
    await expectLater(
      stok.koreksiStok(id, stokBaruMili: -1000, waktu: waktu),
      throwsArgumentError,
    );
    expect(await stok.watchTotalPerProduk().first, isEmpty);
  });

  test('koreksi ke angka yang sama tidak menambah catatan', () async {
    final id = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    final stok = StokStore(database);
    final waktu = DateTime(2026, 10, 17);

    await stok.tambahStok(id, jumlahMili: 5000, waktu: waktu);
    await stok.koreksiStok(id, stokBaruMili: 5000, waktu: waktu);

    expect(await stok.watchPergerakan(id).first, hasLength(1));
  });

  testWidgets('Tambah Stok menaikkan Stok dan tercatat di riwayat', (
    tester,
  ) async {
    await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Kopi Bubuk');
    expect(find.textContaining('Stok: 0'), findsOneWidget);

    await tambahStok(tester, '10');

    expect(find.textContaining('Stok: 10'), findsOneWidget);
    expect(diRiwayat('Tambah Stok'), findsOneWidget);
    expect(diRiwayat('17/10/2026'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('Koreksi Stok menyesuaikan tanpa menghapus catatan sebelumnya', (
    tester,
  ) async {
    await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Kopi Bubuk');
    await tambahStok(tester, '10');
    await koreksiStok(tester, '7');

    expect(find.textContaining('Stok: 7'), findsOneWidget);
    // Dua catatan: Tambah Stok dan Koreksi Stok, bukan satu angka yang ditimpa.
    expect(diRiwayat('Tambah Stok'), findsOneWidget);
    expect(diRiwayat('Koreksi Stok'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('Koreksi Stok menolak angka negatif', (tester) async {
    await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Kopi Bubuk');
    await tambahStok(tester, '10');
    await koreksiStok(tester, '-3');

    expect(find.textContaining('Stok tidak boleh negatif'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('satuan bulat menolak kuantitas pecahan', (tester) async {
    await ProdukStore(
      database,
    ).tambah(nama: 'Sabun', hargaKatalog: 4000, satuan: 'pcs');

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Sabun');
    await tambahStok(tester, '2,5');

    // Dibatasi ke dialog: formulir di belakangnya juga memakai kata yang sama.
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.textContaining('harus bilangan bulat'),
      ),
      findsOneWidget,
    );

    await tutupAplikasi(tester);
  });

  testWidgets('satuan boleh pecahan menerima 2,5', (tester) async {
    await ProdukStore(database).tambah(
      nama: 'Beras',
      hargaKatalog: 12000,
      satuan: 'kg',
      bolehPecahan: true,
    );

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Beras');
    await tambahStok(tester, '2,5');

    expect(find.textContaining('Stok: 2,5'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('produk baru mulai dari Stok nol lewat Tambah Stok pertama', (
    tester,
  ) async {
    await bukaProduk(tester);
    await tester.tap(find.byKey(const Key('produk-tambah')));
    await tester.pumpAndSettle();

    // Tidak ada kolom Stok di formulir produk baru.
    expect(find.textContaining('Stok'), findsNothing);

    await tester.enterText(find.byKey(const Key('produk-form-nama')), 'Gula');
    await tester.enterText(find.byKey(const Key('produk-form-harga')), '14000');
    await tester.enterText(find.byKey(const Key('produk-form-satuan')), 'kg');
    await tester.tap(find.byKey(const Key('produk-form-simpan')));
    await tester.pumpAndSettle();

    await bukaProdukBernama(tester, 'Gula');
    expect(find.textContaining('Stok: 0'), findsOneWidget);

    await tambahStok(tester, '5');
    expect(find.textContaining('Stok: 5'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('daftar Produk menampilkan Stok tiap produk', (tester) async {
    await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');

    await bukaProduk(tester);
    await bukaProdukBernama(tester, 'Kopi Bubuk');
    await tambahStok(tester, '10');
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.textContaining('stok 10'), findsOneWidget);

    await tutupAplikasi(tester);
  });
}
