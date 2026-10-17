import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/kategori_store.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';

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
    await PinStore(database).simpan('1234');

    final produk = ProdukStore(database);
    final stok = StokStore(database);
    final waktu = DateTime(2026, 10, 17, 9);
    final minuman = await KategoriStore(database).tambah('Minuman');

    kopiId = await produk.tambah(
      nama: 'Kopi Bubuk',
      hargaKatalog: 15000,
      satuan: 'pcs',
      kategoriId: minuman,
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

    await stok.tambahStok(kopiId, jumlahMili: 10000, waktu: waktu);
    await stok.tambahStok(berasId, jumlahMili: 5000, waktu: waktu);
  });
  tearDown(() => database.close());

  Future<void> bukaKasir(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();
  }

  /// Menekan kartu Produk di katalog. Dikunci lewat kunci, bukan teks, karena
  /// nama Produk juga muncul di baris Keranjang setelah ditambahkan.
  Future<void> tekanProduk(WidgetTester tester, int id) async {
    await tester.tap(find.byKey(Key('kasir-produk-$id')));
    await tester.pumpAndSettle();
  }

  String teksKunci(WidgetTester tester, String kunci) =>
      tester.widget<Text>(find.byKey(Key(kunci))).data!;

  String isiKolom(WidgetTester tester, String kunci) =>
      tester.widget<TextField>(find.byKey(Key(kunci))).controller!.text;

  testWidgets('menekan Produk memasukkan baris dan menekannya lagi menambah', (
    tester,
  ) async {
    await bukaKasir(tester);

    await tekanProduk(tester, kopiId);
    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp15.000');

    await tekanProduk(tester, kopiId);
    expect(isiKolom(tester, 'keranjang-qty-$kopiId'), '2');
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp30.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Kuantitas bisa diubah langsung dari Keranjang', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await tester.enterText(find.byKey(Key('keranjang-qty-$kopiId')), '3');
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp45.000');

    await tutupAplikasi(tester);
  });

  testWidgets('baris bisa dihapus dari Keranjang', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await tester.tap(find.byKey(Key('keranjang-hapus-$kopiId')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsNothing);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp0');

    await tutupAplikasi(tester);
  });

  testWidgets('Kuantitas pecahan ditolak untuk Satuan bulat', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await tester.enterText(find.byKey(Key('keranjang-qty-$kopiId')), '2,5');
    await tester.pumpAndSettle();

    expect(find.textContaining('harus bilangan bulat'), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Kuantitas pecahan diterima untuk Satuan boleh pecahan', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, berasId);

    await tester.enterText(find.byKey(Key('keranjang-qty-$berasId')), '2,5');
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp30.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Produk dengan Stok nol tidak bisa masuk Keranjang', (
    tester,
  ) async {
    await bukaKasir(tester);

    await tekanProduk(tester, sabunId);

    expect(find.textContaining('Stok Sabun masih nol'), findsOneWidget);
    expect(find.textContaining('Isi Stok dulu'), findsOneWidget);
    expect(find.byKey(Key('keranjang-baris-$sabunId')), findsNothing);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('katalog bisa disaring per Kategori dan dicari', (tester) async {
    await bukaKasir(tester);

    await tester.tap(find.text('Minuman'));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('kasir-produk-$kopiId')), findsOneWidget);
    expect(find.byKey(Key('kasir-produk-$berasId')), findsNothing);

    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('kasir-cari')), 'ber');
    await tester.pumpAndSettle();
    expect(find.byKey(Key('kasir-produk-$berasId')), findsOneWidget);
    expect(find.byKey(Key('kasir-produk-$kopiId')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('layar lebar menampilkan katalog dan Keranjang berdampingan', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    // Tanpa membuka apa pun: baris Keranjang dan Subtotal sudah terlihat.
    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.byKey(const Key('kasir-buka-keranjang')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('layar sempit menyembunyikan Keranjang, Total tetap terlihat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsNothing);
    expect(find.textContaining('Total'), findsWidgets);

    await tester.tap(find.byKey(const Key('kasir-buka-keranjang')));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Harga baris tidak bisa diubah dari layar kasir', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    final baris = find.byKey(Key('keranjang-baris-$kopiId'));
    // Satu-satunya kolom yang bisa diketik di baris itu adalah Kuantitas.
    expect(
      find.descendant(of: baris, matching: find.byType(TextField)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: baris, matching: find.text('Rp15.000 per pcs')),
      findsOneWidget,
    );

    await tutupAplikasi(tester);
  });
}
