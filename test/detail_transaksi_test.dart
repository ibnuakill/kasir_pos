import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';

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

    await stok.tambahStok(kopiId, jumlahMili: 10000, waktu: waktu);
    await stok.tambahStok(berasId, jumlahMili: 10000, waktu: waktu);
  });

  tearDown(() => database.close());

  Future<TransaksiData> catat(
    DateTime waktu, {
    required int produkId,
    int kuantitasMili = 1000,
  }) async {
    final produk = await ProdukStore(database).cari(produkId);
    return TransaksiStore(database).simpan(
      waktu: waktu,
      metodeBayar: MetodeBayar.tunai,
      baris: [BarisTerjual(produk: produk!, kuantitasMili: kuantitasMili)],
    );
  }

  Future<int> stokSekarang(int produkId) async {
    final pergerakan = await database.select(database.pergerakanStok).get();
    return pergerakan
        .where((p) => p.produkId == produkId)
        .fold<int>(0, (jumlah, p) => jumlah + p.jumlahMili);
  }

  /// Membuka Laporan lalu detail Transaksi pertama.
  Future<void> bukaDetail(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laporan').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('laporan-transaksi-1')));
    await tester.pumpAndSettle();
  }

  /// Menekan Batalkan lalu memasukkan PIN yang benar.
  Future<void> batalkanDenganPin(WidgetTester tester, String alasan) async {
    await tester.tap(find.byKey(const Key('detail-batal')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('pin-input')), '1234');
    await tester.tap(find.byKey(const Key('pin-buka')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('detail-alasan')), alasan);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-batal-konfirmasi')));
    await tester.pumpAndSettle();
  }

  String teksKunci(WidgetTester tester, String kunci) =>
      tester.widget<Text>(find.byKey(Key(kunci))).data!;

  testWidgets('detail menampilkan isi Transaksi yang bisa dibagikan', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);

    await bukaDetail(tester);

    expect(find.text('Detail Transaksi'), findsOneWidget);
    expect(teksKunci(tester, 'struk-nomor'), 'TRX-20261017-001');
    expect(find.text('Kopi Bubuk'), findsOneWidget);
    expect(teksKunci(tester, 'struk-total'), 'Rp15.000');
    expect(find.byKey(const Key('detail-bagikan')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('membatalkan menuntut PIN lebih dulu', (tester) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await bukaDetail(tester);

    await tester.tap(find.byKey(const Key('detail-batal')));
    await tester.pumpAndSettle();

    // Yang muncul PIN, bukan langsung kotak alasan.
    expect(find.byKey(const Key('pin-input')), findsOneWidget);
    expect(find.byKey(const Key('detail-alasan')), findsNothing);

    // Batal di dialog PIN berarti tidak ada yang berubah.
    await tester.tap(find.byKey(const Key('pin-batal')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detail-batal-banner')), findsNothing);
    expect((await TransaksiStore(database).cari(1))!.batal, isFalse);

    await tutupAplikasi(tester);
  });

  testWidgets('PIN salah tidak membuka kotak alasan', (tester) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await bukaDetail(tester);

    await tester.tap(find.byKey(const Key('detail-batal')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('pin-input')), '9999');
    await tester.tap(find.byKey(const Key('pin-buka')));
    await tester.pumpAndSettle();

    expect(find.text('PIN salah'), findsOneWidget);
    expect(find.byKey(const Key('detail-alasan')), findsNothing);
    expect((await TransaksiStore(database).cari(1))!.batal, isFalse);

    await tutupAplikasi(tester);
  });

  testWidgets('alasan wajib diisi sebelum pembatalan bisa dikonfirmasi', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await bukaDetail(tester);

    await tester.tap(find.byKey(const Key('detail-batal')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('pin-input')), '1234');
    await tester.tap(find.byKey(const Key('pin-buka')));
    await tester.pumpAndSettle();

    FilledButton konfirmasi() => tester.widget<FilledButton>(
      find.byKey(const Key('detail-batal-konfirmasi')),
    );

    expect(konfirmasi().onPressed, isNull);

    // Spasi saja tidak dihitung sebagai alasan.
    await tester.enterText(find.byKey(const Key('detail-alasan')), '   ');
    await tester.pumpAndSettle();
    expect(konfirmasi().onPressed, isNull);

    await tester.enterText(find.byKey(const Key('detail-alasan')), 'Salah input');
    await tester.pumpAndSettle();
    expect(konfirmasi().onPressed, isNotNull);

    await tutupAplikasi(tester);
  });

  testWidgets('membatalkan mengembalikan Stok dan menandai Transaksi batal', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId, kuantitasMili: 2500);
    expect(await stokSekarang(kopiId), 7500);

    await bukaDetail(tester);
    await batalkanDenganPin(tester, 'Salah input');

    // Stok kembali persis seperti sebelum terjual.
    expect(await stokSekarang(kopiId), 10000);

    final transaksi = (await TransaksiStore(database).cari(1))!;
    expect(transaksi.batal, isTrue);
    expect(transaksi.alasanBatal, 'Salah input');
    expect(transaksi.waktuBatal, DateTime(2026, 10, 17, 9, 30));

    // Layar langsung menunjukkan tanda batal tanpa perlu dibuka ulang.
    expect(find.byKey(const Key('detail-batal-banner')), findsOneWidget);
    expect(teksKunci(tester, 'detail-alasan-batal'), 'Alasan: Salah input');
    expect(find.byKey(const Key('detail-batal')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('Transaksi batal tetap di daftar tapi tidak dihitung Omzet', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await catat(DateTime(2026, 10, 17, 10), produkId: berasId);

    await bukaDetail(tester);
    await batalkanDenganPin(tester, 'Pembeli batal beli');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Omzet hanya dari Transaksi yang tidak batal: 12.000.
    expect(teksKunci(tester, 'laporan-omzet'), 'Rp12.000');
    expect(teksKunci(tester, 'laporan-jumlah'), '1');

    // Barisnya masih ada, lengkap dengan alasannya.
    expect(find.text('TRX-20261017-001'), findsOneWidget);
    expect(
      teksKunci(tester, 'laporan-batal-1'),
      'Batal · Pembeli batal beli',
    );

    await tutupAplikasi(tester);
  });

  testWidgets('Transaksi yang sudah batal tidak bisa dibatalkan lagi', (
    tester,
  ) async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    await TransaksiStore(database).batalkan(
      1,
      alasan: 'Salah input',
      waktu: DateTime(2026, 10, 17, 10),
    );

    await bukaDetail(tester);

    expect(find.byKey(const Key('detail-batal-banner')), findsOneWidget);
    // Tombolnya tidak ditawarkan sama sekali, bukan hanya dinonaktifkan.
    expect(find.byKey(const Key('detail-batal')), findsNothing);
    // Stok tetap 10.000, tidak bertambah lagi karena dibuka dua kali.
    expect(await stokSekarang(kopiId), 10000);

    await tutupAplikasi(tester);
  });

  test('pembatalan kedua ditolak di lapisan data, bukan hanya di layar', () async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    final store = TransaksiStore(database);
    final waktu = DateTime(2026, 10, 17, 10);

    await store.batalkan(1, alasan: 'Salah input', waktu: waktu);

    expect(
      () => store.batalkan(1, alasan: 'Salah input lagi', waktu: waktu),
      throwsA(isA<TransaksiSudahBatalException>()),
    );
    expect(await stokSekarang(kopiId), 10000);
  });

  test('alasan kosong ditolak sebelum menyentuh database', () async {
    await catat(DateTime(2026, 10, 17, 9), produkId: kopiId);
    final store = TransaksiStore(database);

    expect(
      () => store.batalkan(
        1,
        alasan: '   ',
        waktu: DateTime(2026, 10, 17, 10),
      ),
      throwsA(isA<ArgumentError>()),
    );
    expect((await store.cari(1))!.batal, isFalse);
    expect(await stokSekarang(kopiId), 9000);
  });
}
