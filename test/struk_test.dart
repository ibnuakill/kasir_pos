import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/pembagi.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';

import 'bantuan.dart';

class _Bagian {
  const _Bagian({required this.nama, required this.teks, required this.panjang});

  final String nama;
  final String teks;
  final int panjang;
}

class _PembagiPalsu implements Pembagi {
  final List<_Bagian> dibagikan = [];
  bool gagal = false;
  bool gagalDipanggil = false;

  @override
  Future<void> bagikanGambar(
    Uint8List png, {
    required String namaBerkas,
    required String teks,
  }) async {
    gagalDipanggil = true;
    if (gagal) throw StateError('lembar berbagi tidak tersedia');
    dibagikan.add(
      _Bagian(nama: namaBerkas, teks: teks, panjang: png.length),
    );
  }

  @override
  Future<void> bagikanBerkas(
    String path, {
    required String namaBerkas,
    required String teks,
  }) async {
    gagalDipanggil = true;
    if (gagal) throw StateError('lembar berbagi tidak tersedia');
    dibagikan.add(
      _Bagian(
        nama: namaBerkas,
        teks: teks,
        panjang: await File(path).length(),
      ),
    );
  }
}

void main() {
  late AppDatabase database;
  late int kopiId;
  late _PembagiPalsu pembagi;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');

    kopiId = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    await StokStore(
      database,
    ).tambahStok(kopiId, jumlahMili: 10000, waktu: DateTime(2026, 10, 17, 9));

    pembagi = _PembagiPalsu();
  });

  tearDown(() => database.close());

  Future<void> bukaKasir(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
        overrides: [pembagiProvider.overrideWithValue(pembagi)],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();
  }

  /// Memasukkan satu Produk ke Keranjang, membayar, lalu menekan Simpan.
  Future<void> jual(
    WidgetTester tester, {
    String uang = '20000',
    bool qris = false,
    String? diskonPersen,
  }) async {
    await tester.tap(find.byKey(Key('kasir-produk-$kopiId')));
    await tester.pumpAndSettle();

    if (diskonPersen != null) {
      await tester.tap(find.byKey(const Key('kasir-atur-diskon')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('diskon-jenis-persen')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('diskon-nilai')),
        diskonPersen,
      );
      await tester.tap(find.byKey(const Key('diskon-simpan')));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const Key('kasir-bayar')));
    await tester.pumpAndSettle();

    if (qris) {
      await tester.tap(find.text('QRIS'));
      await tester.pumpAndSettle();
    } else {
      await tester.enterText(
        find.byKey(const Key('bayar-uang-diterima')),
        uang,
      );
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();
  }

  String teksKunci(WidgetTester tester, String kunci) =>
      tester.widget<Text>(find.byKey(Key(kunci))).data!;

  testWidgets('Struk tampil sendiri begitu Transaksi tersimpan', (tester) async {
    await bukaKasir(tester);
    await jual(tester);

    // Struk menggantikan pesan singkat: Transaksi berhasil ditandai oleh
    // nomornya di atas kertas (user story 51, 53).
    expect(find.text('Struk'), findsOneWidget);
    expect(teksKunci(tester, 'struk-nomor'), 'TRX-20261017-001');
    expect(teksKunci(tester, 'struk-waktu'), '17/10/2026 09:30');
    expect(teksKunci(tester, 'struk-toko'), 'Warung Bu Sri');
    expect(teksKunci(tester, 'struk-alamat'), 'Jl. Melati 12');

    await tutupAplikasi(tester);
  });

  testWidgets('Struk memuat rincian item, Subtotal, Total, dan Kembalian', (
    tester,
  ) async {
    await bukaKasir(tester);
    await jual(tester);

    // Item: nama, Kuantitas beserta Satuan, dan harga (user story 54).
    expect(find.byKey(const Key('struk-item-0')), findsOneWidget);
    expect(find.text('Kopi Bubuk'), findsOneWidget);
    expect(find.text('1 pcs × Rp15.000'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(teksKunci(tester, 'struk-subtotal'), 'Rp15.000');

    // Subtotal, Total, Metode Bayar, dan Kembalian (user story 55, 56).
    expect(teksKunci(tester, 'struk-total'), 'Rp15.000');
    expect(find.text('Metode Bayar'), findsOneWidget);
    expect(find.text('Tunai'), findsOneWidget);
    expect(teksKunci(tester, 'struk-kembalian'), 'Rp5.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Diskon tampil sebagai baris potongan, bukan disembunyikan', (
    tester,
  ) async {
    await bukaKasir(tester);
    await jual(tester, diskonPersen: '10');

    expect(find.text('Diskon 10%'), findsOneWidget);
    expect(teksKunci(tester, 'struk-diskon'), '-Rp1.500');
    expect(teksKunci(tester, 'struk-total'), 'Rp13.500');

    await tutupAplikasi(tester);
  });

  testWidgets('Struk QRIS tidak menampilkan Kembalian', (tester) async {
    await bukaKasir(tester);
    await jual(tester, qris: true);

    expect(find.text('QRIS'), findsOneWidget);
    expect(find.byKey(const Key('struk-kembalian')), findsNothing);
    expect(find.text('Kembalian'), findsNothing);
    expect(teksKunci(tester, 'struk-total'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Bagikan Struk menyerahkan gambar bernama nomor Transaksi', (
    tester,
  ) async {
    await bukaKasir(tester);
    await jual(tester);

    // Render Struk jadi PNG butuh event loop sungguhan; di zona waktu palsu
    // `toImage` tidak pernah selesai.
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('struk-bagikan')));
      for (var i = 0; i < 100 && pembagi.dibagikan.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();

    expect(pembagi.dibagikan, hasLength(1));
    final bagian = pembagi.dibagikan.single;
    expect(bagian.nama, 'struk-TRX-20261017-001.png');
    expect(bagian.teks, contains('TRX-20261017-001'));
    // PNG sungguhan hasil render Struk, bukan gambar kosong.
    expect(bagian.panjang, greaterThan(1000));

    await tutupAplikasi(tester);
  });

  testWidgets('gagal membagikan diberi tahu tanpa menutup Struk', (
    tester,
  ) async {
    pembagi.gagal = true;

    await bukaKasir(tester);
    await jual(tester);
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('struk-bagikan')));
      for (var i = 0; i < 100 && !pembagi.gagalDipanggil; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();

    expect(find.text('Struk gagal dibagikan'), findsOneWidget);
    // Struk tetap di layar supaya kasir bisa mencoba lagi.
    expect(find.byKey(const Key('struk-kertas')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('Selesai menutup Struk dan Keranjang sudah kosong', (
    tester,
  ) async {
    await bukaKasir(tester);
    await jual(tester);

    await tester.tap(find.byKey(const Key('struk-selesai')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('struk-kertas')), findsNothing);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupAplikasi(tester);
  });
}
