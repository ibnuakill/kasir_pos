import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/keranjang_store.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';

import 'bantuan.dart';

void main() {
  late AppDatabase database;
  late int kopiId;
  late int berasId;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');

    final produk = ProdukStore(database);
    final stok = StokStore(database);
    final waktu = DateTime(2026, 10, 17, 8);

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

    await stok.tambahStok(kopiId, jumlahMili: 10000, waktu: waktu);
    await stok.tambahStok(berasId, jumlahMili: 10000, waktu: waktu);
  });

  tearDown(() => database.close());

  /// Membuka aplikasi lalu pindah ke layar Kasir. Dipanggil dua kali dalam satu
  /// test untuk meniru aplikasi yang ditutup lalu dibuka lagi.
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

  /// Menutup aplikasi tanpa mengosongkan apa pun, seperti aplikasi dimatikan.
  Future<void> tutupDanBukaKasir(WidgetTester tester) async {
    await tutupAplikasi(tester);
    await bukaKasir(tester);
  }

  Future<void> tekanProduk(WidgetTester tester, int id, {int kali = 1}) async {
    for (var i = 0; i < kali; i++) {
      await tester.tap(find.byKey(Key('kasir-produk-$id')));
      await tester.pumpAndSettle();
    }
  }

  Future<void> pasangDiskonPersen(WidgetTester tester, String persen) async {
    await tester.tap(find.byKey(const Key('kasir-atur-diskon')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('diskon-jenis-persen')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('diskon-nilai')), persen);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('diskon-simpan')));
    await tester.pumpAndSettle();
  }

  Future<void> bayarTunai(WidgetTester tester, String uang) async {
    await tester.tap(find.byKey(const Key('kasir-bayar')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('bayar-uang-diterima')),
      uang,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bayar-simpan')));
    await tester.pumpAndSettle();
  }

  String teksKunci(WidgetTester tester, String kunci) =>
      tester.widget<Text>(find.byKey(Key(kunci))).data!;

  testWidgets('Keranjang pulih utuh setelah aplikasi dibuka kembali', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId, kali: 2);
    await tekanProduk(tester, berasId);
    await pasangDiskonPersen(tester, '10');

    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp42.000');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp37.800');

    await tutupDanBukaKasir(tester);

    // Baris, Kuantitas, dan Diskon kembali seperti ditinggalkan.
    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);
    expect(find.byKey(Key('keranjang-baris-$berasId')), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp42.000');
    expect(teksKunci(tester, 'keranjang-total'), 'Rp37.800');
    // Diskon 10% dari 42.000 ikut pulih, bukan hilang jadi 0.
    expect(teksKunci(tester, 'keranjang-diskon'), 'Rp4.200');

    await tutupAplikasi(tester);
  });

  testWidgets('Kuantitas yang diubah ikut tersimpan, bukan hanya barisnya', (
    tester,
  ) async {
    await bukaKasir(tester);
    // Beras dijual per kg, jadi Kuantitas pecahannya sah.
    await tekanProduk(tester, berasId, kali: 3);

    await tester.enterText(find.byKey(Key('keranjang-qty-$berasId')), '0.5');
    await tester.pumpAndSettle();
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp6.000');

    await tutupDanBukaKasir(tester);

    expect(
      tester
          .widget<TextField>(find.byKey(Key('keranjang-qty-$berasId')))
          .controller
          ?.text,
      '0,5',
    );
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp6.000');

    await tutupAplikasi(tester);
  });

  testWidgets('menyimpan Transaksi mengosongkan Keranjang yang dipulihkan', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await tutupDanBukaKasir(tester);
    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);

    await bayarTunai(tester, '20000');
    await tester.tap(find.byKey(const Key('struk-selesai')));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupDanBukaKasir(tester);

    // Transaksi berikutnya mulai dari nol, bukan dari Keranjang tadi.
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(teksKunci(tester, 'keranjang-total'), 'Rp0');

    await tutupAplikasi(tester);
  });

  testWidgets('mengosongkan Keranjang sengaja tidak memulihkannya lagi', (
    tester,
  ) async {
    await bukaKasir(tester);
    await tekanProduk(tester, kopiId);
    await pasangDiskonPersen(tester, '10');

    await tester.tap(find.byKey(const Key('keranjang-kosongkan')));
    await tester.pumpAndSettle();
    // Salah tekan belum mengosongkan apa pun.
    await tester.tap(find.byKey(const Key('keranjang-kosongkan-batal')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('keranjang-baris-$kopiId')), findsOneWidget);

    await tester.tap(find.byKey(const Key('keranjang-kosongkan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('keranjang-kosongkan-konfirmasi')));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupDanBukaKasir(tester);

    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('Keranjang yang tidak bisa dibaca membuat aplikasi tetap terbuka', (
    tester,
  ) async {
    // Isi simpanan yang bukan bentuk yang dikenal: lebih baik mulai kosong
    // daripada gagal membuka aplikasi.
    await database.setSetting(KeranjangStore.kunci, '{bukan json');
    await bukaKasir(tester);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('baris yang Produknya sudah tidak ada dilewati', (tester) async {
    await KeranjangStore(database).simpan(
      const IsiKeranjangTersimpan(
        baris: [
          BarisKeranjangTersimpan(produkId: 999, kuantitasMili: 2000),
          BarisKeranjangTersimpan(produkId: 0, kuantitasMili: 1000),
        ],
      ),
    );
    await bukaKasir(tester);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);

    // Yang tersisa tidak menghalangi Produk asli masuk lagi.
    await tekanProduk(tester, kopiId);
    expect(teksKunci(tester, 'keranjang-subtotal'), 'Rp15.000');

    await tutupAplikasi(tester);
  });

  test('KeranjangStore menyimpan baris dan Diskon, lalu menghapusnya', () async {
    final store = KeranjangStore(database);

    expect(await store.baca(), isNull);

    await store.simpan(
      const IsiKeranjangTersimpan(
        baris: [BarisKeranjangTersimpan(produkId: 1, kuantitasMili: 2500)],
        diskon: Diskon(jenis: JenisDiskon.nominal, nilai: 500),
      ),
    );

    final dibaca = (await store.baca())!;
    expect(dibaca.baris.single.produkId, 1);
    expect(dibaca.baris.single.kuantitasMili, 2500);
    expect(dibaca.diskon, const Diskon(jenis: JenisDiskon.nominal, nilai: 500));

    await store.hapus();
    expect(await store.baca(), isNull);
  });

  test('Kuantitas nol tidak ikut dipulihkan', () async {
    final store = KeranjangStore(database);
    await database.setSetting(
      KeranjangStore.kunci,
      '{"baris":[{"produk":1,"kuantitas":0}],"diskon":null}',
    );

    // Satu-satunya baris tidak sah, jadi tidak ada Keranjang untuk dipulihkan.
    expect(await store.baca(), isNull);
  });
}
