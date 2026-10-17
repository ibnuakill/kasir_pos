import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/pin_store.dart';
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

  /// Formulir Produk memuat bagian foto, jadi layar uji dibuat tinggi supaya
  /// seluruh isinya terbangun tanpa perlu menggulir.
  void layarTinggi(WidgetTester tester) {
    tester.view.physicalSize = const Size(500, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> bukaProduk(WidgetTester tester) async {
    layarTinggi(tester);
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

  Future<void> isiProduk(
    WidgetTester tester, {
    required String nama,
    String harga = '15000',
    String satuan = 'pcs',
    bool bolehPecahan = false,
  }) async {
    await tester.tap(find.byKey(const Key('produk-tambah')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('produk-form-nama')), nama);
    await tester.enterText(find.byKey(const Key('produk-form-harga')), harga);
    await tester.enterText(find.byKey(const Key('produk-form-satuan')), satuan);
    if (bolehPecahan) {
      await tester.tap(find.byKey(const Key('produk-form-pecahan')));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(const Key('produk-form-simpan')));
    await tester.pumpAndSettle();
  }

  testWidgets('produk baru muncul di daftar dengan harga Rupiah', (
    tester,
  ) async {
    await bukaProduk(tester);
    await isiProduk(tester, nama: 'Kopi Bubuk', harga: '15000', satuan: 'pcs');

    expect(find.text('Kopi Bubuk'), findsOneWidget);
    expect(find.textContaining('Rp15.000'), findsOneWidget);
    // Tidak ada angka mentah yang bocor ke layar.
    expect(find.textContaining('15000'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('satuan boleh pecahan tersimpan pada produk', (tester) async {
    await bukaProduk(tester);
    await isiProduk(
      tester,
      nama: 'Beras',
      harga: '12000',
      satuan: 'kg',
      bolehPecahan: true,
    );

    await tester.tap(find.text('Beras'));
    await tester.pumpAndSettle();

    final saklar = tester.widget<SwitchListTile>(
      find.byKey(const Key('produk-form-pecahan')),
    );
    expect(saklar.value, isTrue);
    expect(
      tester.widget<TextFormField>(find.byKey(const Key('produk-form-satuan')))
          .controller
          ?.text,
      'kg',
    );

    await tutupAplikasi(tester);
  });

  testWidgets('kategori dibuat lalu dipakai mengelompokkan produk', (
    tester,
  ) async {
    await bukaProduk(tester);
    await tester.tap(find.byKey(const Key('produk-tambah')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('produk-form-kategori-baru')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('kategori-baru-nama')),
      'Minuman',
    );
    await tester.tap(find.byKey(const Key('kategori-baru-simpan')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('produk-form-nama')), 'Teh Manis');
    await tester.enterText(find.byKey(const Key('produk-form-harga')), '5000');
    await tester.enterText(find.byKey(const Key('produk-form-satuan')), 'gelas');
    await tester.tap(find.byKey(const Key('produk-form-simpan')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Minuman'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('produk nonaktif hilang dari daftar aktif tapi tetap ada di semua', (
    tester,
  ) async {
    await bukaProduk(tester);
    await isiProduk(tester, nama: 'Sabun Mandi', harga: '4000', satuan: 'pcs');

    await tester.tap(find.text('Sabun Mandi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('produk-form-nonaktifkan')));
    await tester.pumpAndSettle();

    expect(find.text('Sabun Mandi'), findsNothing);

    await tester.tap(find.byKey(const Key('produk-tampilkan-nonaktif')));
    await tester.pumpAndSettle();

    expect(find.text('Sabun Mandi'), findsOneWidget);
    expect(find.textContaining('Nonaktif'), findsWidgets);

    await tutupAplikasi(tester);
  });

  testWidgets('pencarian nama menyaring daftar produk', (tester) async {
    await bukaProduk(tester);
    await isiProduk(tester, nama: 'Kopi Bubuk', harga: '15000', satuan: 'pcs');
    await isiProduk(tester, nama: 'Gula Pasir', harga: '14000', satuan: 'kg');

    await tester.enterText(find.byKey(const Key('produk-cari')), 'kopi');
    await tester.pumpAndSettle();

    expect(find.text('Kopi Bubuk'), findsOneWidget);
    expect(find.text('Gula Pasir'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('harga kosong atau nol ditolak', (tester) async {
    await bukaProduk(tester);
    await tester.tap(find.byKey(const Key('produk-tambah')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('produk-form-nama')), 'Tanpa Harga');
    await tester.enterText(find.byKey(const Key('produk-form-harga')), '0');
    await tester.enterText(find.byKey(const Key('produk-form-satuan')), 'pcs');
    await tester.tap(find.byKey(const Key('produk-form-simpan')));
    await tester.pumpAndSettle();

    expect(find.text('Harga harus lebih dari nol'), findsOneWidget);
    // Masih di formulir: produk belum tersimpan.
    expect(find.byKey(const Key('produk-form-nama')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('tidak ada tombol hapus permanen di formulir produk', (
    tester,
  ) async {
    await bukaProduk(tester);
    await isiProduk(tester, nama: 'Kopi Bubuk', harga: '15000', satuan: 'pcs');

    await tester.tap(find.text('Kopi Bubuk'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hapus'), findsNothing);

    await tutupAplikasi(tester);
  });
}
