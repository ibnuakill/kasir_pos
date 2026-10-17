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

  Future<void> aturDiskon(
    WidgetTester tester, {
    required String nilai,
    bool persen = false,
  }) async {
    await tester.tap(find.byKey(const Key('kasir-atur-diskon')));
    await tester.pumpAndSettle();

    if (persen) {
      await tester.tap(find.byKey(const Key('diskon-jenis-persen')));
      await tester.pumpAndSettle();
    }

    await tester.enterText(find.byKey(const Key('diskon-nilai')), nilai);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('diskon-simpan')));
    await tester.pumpAndSettle();
  }

  testWidgets('Diskon nominal mengurangi Total', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await aturDiskon(tester, nilai: '5000');

    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp15.000');
    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp5.000');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp10.000');

    await tutupAplikasi(tester);
  });

  testWidgets('Diskon persen dihitung dari Subtotal', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await aturDiskon(tester, nilai: '10', persen: true);

    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp1.500');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp13.500');
    expect(find.textContaining('10%'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('Diskon melebihi Subtotal membuat Total nol, bukan minus', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);

    await aturDiskon(tester, nilai: '99999');

    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp15.000');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp0');

    await tutupAplikasi(tester);
  });

  testWidgets('Diskon bisa dihapus sehingga Total kembali ke Subtotal', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await aturDiskon(tester, nilai: '5000');

    await tester.tap(find.byKey(const Key('kasir-atur-diskon')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('diskon-hapus')));
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp0');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp15.000');
    expect(find.textContaining('10%'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('Diskon ikut hilang saat baris terakhir dihapus', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await aturDiskon(tester, nilai: '5000');

    await tester.tap(find.byKey(Key('keranjang-hapus-$kopiId')));
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp0');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp0');

    // Belanja berikutnya tidak mewarisi potongan lama.
    await tekanProduk(tester, kopiId);
    expect(teksKunci(tester, 'keranjang-total'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  Future<void> bukaPembayaran(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('kasir-bayar')));
    await tester.pumpAndSettle();
  }

  Future<void> isiUang(WidgetTester tester, String teks) async {
    await tester.enterText(find.byKey(const Key('bayar-uang-diterima')), teks);
    await tester.pumpAndSettle();
  }

  /// Struk terbuka sendiri setelah Transaksi tersimpan; ditutup dulu sebelum
  /// memeriksa layar kasir di belakangnya.
  Future<void> tutupStruk(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('struk-selesai')));
    await tester.pumpAndSettle();
  }

  testWidgets('Kembalian dihitung otomatis dari uang diterima', (tester) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);

    expect(teksKunci(tester, 'bayar-total'), 'Rp15.000');
    expect(teksKunci(tester, 'bayar-kembalian'), 'Rp0');

    await isiUang(tester, '20000');

    expect(teksKunci(tester, 'bayar-kembalian'), 'Rp5.000');
    expect(find.byKey(const Key('bayar-error')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('Uang kurang dari Total ditolak dengan pesan yang jelas', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);

    await isiUang(tester, '10000');

    expect(teksKunci(tester, 'bayar-error'), 'Uang diterima kurang dari Total');
    expect(teksKunci(tester, 'bayar-kembalian'), 'Rp0');

    // Menekan tombol simpan tidak menyimpan apa pun; lembar tetap terbuka.
    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('bayar-uang-diterima')), findsOneWidget);
    expect(find.textContaining('tersimpan'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('Simpan Transaksi memberi nomor dan mengosongkan Keranjang', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);
    await isiUang(tester, '20000');

    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();

    // Tanda Transaksi tersimpan adalah Struk yang langsung terbuka.
    expect(teksKunci(tester, 'struk-nomor'), 'TRX-20261017-001');

    await tutupStruk(tester);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-total'), 'Rp0');

    await tutupAplikasi(tester);
  });

  testWidgets('Transaksi berikutnya mendapat nomor urut setelahnya', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);
    await isiUang(tester, '15000');
    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();

    await tutupStruk(tester);

    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);
    await isiUang(tester, '15000');
    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();

    expect(teksKunci(tester, 'struk-nomor'), 'TRX-20261017-002');

    await tutupAplikasi(tester);
  });

  testWidgets('Stok berkurang begitu Transaksi tersimpan', (tester) async {
    await bukaKasir(tester);
    expect(find.text('stok 10'), findsOneWidget);

    await tekanProduk(tester, kopiId);
    await bukaPembayaran(tester);
    await isiUang(tester, '15000');
    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();
    await tutupStruk(tester);

    expect(find.text('stok 9'), findsOneWidget);

    await tutupAplikasi(tester);
  });
}
