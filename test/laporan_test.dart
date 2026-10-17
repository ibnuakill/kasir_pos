import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';

import 'bantuan.dart';

void main() {
  late AppDatabase database;
  late int kopiId;
  late int berasId;
  late int sabunId;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));

    final produk = ProdukStore(database);
    final stok = StokStore(database);
    final waktu = DateTime(2026, 10, 1, 8);

    kopiId = await produk.tambah(
      nama: 'Kopi Bubuk',
      hargaKatalog: 15000,
      satuan: 'pcs',
    );
    berasId = await produk.tambah(
      nama: 'Beras',
      hargaKatalog: 12000,
      satuan: 'kg',
      bolehPecahan: true,
    );
    sabunId = await produk.tambah(
      nama: 'Sabun',
      hargaKatalog: 4000,
      satuan: 'pcs',
    );

    for (final id in [kopiId, berasId, sabunId]) {
      await stok.tambahStok(id, jumlahMili: 20000, waktu: waktu);
    }
  });

  tearDown(() => database.close());

  /// Mencatat satu Transaksi langsung ke database, tanpa lewat layar kasir:
  /// yang diuji di sini adalah cara Laporan membacanya.
  Future<TransaksiData> catat(
    DateTime waktu, {
    required int produkId,
    int kuantitasMili = 1000,
    MetodeBayar metodeBayar = MetodeBayar.tunai,
  }) async {
    final produk = await ProdukStore(database).cari(produkId);
    return TransaksiStore(database).simpan(
      waktu: waktu,
      metodeBayar: metodeBayar,
      baris: [BarisTerjual(produk: produk!, kuantitasMili: kuantitasMili)],
    );
  }

  Future<void> bukaLaporan(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laporan').last);
    await tester.pumpAndSettle();
  }

  String teksKunci(WidgetTester tester, String kunci) =>
      tester.widget<Text>(find.byKey(Key(kunci))).data!;

  testWidgets('hari ini menampilkan Omzet dan jumlah Transaksi', (tester) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await catat(DateTime(2026, 10, 17, 10), produkId: berasId);

    await bukaLaporan(tester);

    expect(teksKunci(tester, 'laporan-tanggal'), '17/10/2026');
    expect(find.text('Hari ini'), findsOneWidget);
    // 15.000 + 12.000
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp27.000');
    expect(teksKunci(tester, 'laporan-jumlah'), '2');

    await tutupAplikasi(tester);
  });

  testWidgets('daftar Transaksi tampil urut waktu dengan jam dan metode', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 14, 5), produkId: sabunId);
    await catat(
      DateTime(2026, 10, 17, 8, 15),
      produkId: kopiId,
      metodeBayar: MetodeBayar.qris,
    );

    await bukaLaporan(tester);

    expect(find.text('TRX-20261017-001'), findsOneWidget);
    expect(find.text('TRX-20261017-002'), findsOneWidget);
    // Urutan mengikuti jam, bukan urutan pencatatan.
    expect(find.text('08:15 · QRIS'), findsOneWidget);
    expect(find.text('14:05 · Tunai'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('hari tanpa Transaksi menampilkan nol dan pesan kosong', (
    tester,
  ) async {
    await bukaLaporan(tester);
    await tester.tap(find.byKey(const Key('laporan-hari-sebelumnya')));
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'laporan-tanggal'), '16/10/2026');
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp0');
    expect(teksKunci(tester, 'laporan-jumlah'), '0');
    expect(find.byKey(const Key('laporan-kosong')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('menggeser ke hari sebelumnya menampilkan hari itu saja', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await catat(DateTime(2026, 10, 16, 16), produkId: sabunId);

    await bukaLaporan(tester);
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp15.000');

    await tester.tap(find.byKey(const Key('laporan-hari-sebelumnya')));
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'laporan-tanggal'), '16/10/2026');
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp4.000');
    expect(teksKunci(tester, 'laporan-jumlah'), '1');
    expect(find.text('TRX-20261016-001'), findsOneWidget);
    expect(find.text('TRX-20261017-001'), findsNothing);

    // Kembali ke hari ini.
    await tester.tap(find.byKey(const Key('laporan-hari-berikutnya')));
    await tester.pumpAndSettle();
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  testWidgets('tombol hari berikutnya mati saat sudah di hari ini', (
    tester,
  ) async {
    await bukaLaporan(tester);

    IconButton tombol() => tester.widget<IconButton>(
      find.byKey(const Key('laporan-hari-berikutnya')),
    );

    expect(tombol().onPressed, isNull);

    await tester.tap(find.byKey(const Key('laporan-hari-sebelumnya')));
    await tester.pumpAndSettle();
    expect(tombol().onPressed, isNotNull);

    await tutupAplikasi(tester);
  });

  testWidgets('Transaksi pukul 23:59 masuk hari itu, pukul 00:00 besok tidak', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 23, 59), produkId: kopiId);
    await catat(DateTime(2026, 10, 18, 0, 0), produkId: berasId);

    await bukaLaporan(tester);

    expect(teksKunci(tester, 'laporan-jumlah'), '1');
    expect(find.text('TRX-20261017-001'), findsOneWidget);
    expect(find.text('TRX-20261018-001'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('membuka Transaksi dari daftar menampilkan detailnya', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);

    await bukaLaporan(tester);
    await tester.tap(find.byKey(const Key('laporan-transaksi-1')));
    await tester.pumpAndSettle();

    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(teksKunci(tester, 'struk-nomor'), 'TRX-20261017-001');
    expect(find.text('Kopi Bubuk'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(teksKunci(tester, 'laporan-tanggal'), '17/10/2026');

    await tutupAplikasi(tester);
  });
}
