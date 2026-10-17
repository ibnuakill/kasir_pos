import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/pemilih_gambar.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/qris_store.dart';
import 'package:kasir/data/setting_keys.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:path/path.dart' as p;

import 'bantuan.dart';

/// PNG 1×1 sungguhan, cukup untuk membuktikan berkas tersalin dan bisa
/// ditampilkan tanpa membawa berkas biner ke dalam repo.
final _pngKecil = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFAAH/'
  'q842iQAAAABJRU5ErkJggg==',
);

class _PemilihPalsu implements PemilihGambar {
  _PemilihPalsu(this.berkas);

  /// Berkas yang "dipilih" pengguna; null berarti galeri ditutup.
  String? berkas;
  int dipanggil = 0;

  @override
  Future<String?> dariGaleri() async {
    dipanggil++;
    return berkas;
  }

  @override
  Future<String?> dariKamera() async {
    dipanggil++;
    return berkas;
  }
}

/// Pengganti [GambarStore] yang tidak menyentuh berkas sungguhan: di dalam
/// widget test, I/O berkas berjalan di zona waktu palsu dan tidak pernah
/// selesai.
class _GambarPalsu extends GambarStore {
  _GambarPalsu(this.path) : super(() async => Directory.systemTemp);

  final String path;
  int disimpan = 0;
  int dihapus = 0;

  @override
  Future<String> simpanDari(String sumber, {required String nama}) async {
    disimpan++;
    return path;
  }

  @override
  Future<void> hapus(String? path) async {
    dihapus++;
  }
}

void main() {
  late Directory sumber;
  late File gambarContoh;
  late _PemilihPalsu pemilih;
  late _GambarPalsu gambar;

  setUp(() async {
    sumber = await Directory.systemTemp.createTemp('kasir-sumber');
    gambarContoh = File('${sumber.path}/qr.png')..writeAsBytesSync(_pngKecil);
    pemilih = _PemilihPalsu(gambarContoh.path);
    gambar = _GambarPalsu(gambarContoh.path);
  });

  tearDown(() {
    if (sumber.existsSync()) sumber.deleteSync(recursive: true);
  });

  group('GambarStore', () {
    late Directory folder;
    late GambarStore store;

    setUp(() async {
      folder = await Directory.systemTemp.createTemp('kasir-gambar');
      store = GambarStore(() async => folder);
    });

    tearDown(() {
      if (folder.existsSync()) folder.deleteSync(recursive: true);
    });

    test('menyalin berkas ke folder aplikasi dan mengembalikan path-nya', () async {
      final path = await store.simpanDari(gambarContoh.path, nama: 'qris');

      expect(path, p.join(folder.path, 'qris.png'));
      expect(File(path).readAsBytesSync(), _pngKecil);
      // Berkas asli tidak dipindah, hanya disalin.
      expect(gambarContoh.existsSync(), isTrue);
    });

    test('mengganti gambar membuang berkas lama, bukan menumpuk', () async {
      await store.simpanDari(gambarContoh.path, nama: 'qris');
      final lain = File('${sumber.path}/qr.jpg')..writeAsBytesSync(_pngKecil);
      await store.simpanDari(lain.path, nama: 'qris');

      final isi = folder.listSync().whereType<File>();
      expect(isi.length, 1);
      expect(isi.single.path, endsWith('qris.jpg'));
    });

    test('hapus membuang berkasnya, dan aman untuk path kosong', () async {
      final path = await store.simpanDari(gambarContoh.path, nama: 'qris');
      await store.hapus(path);
      await store.hapus(null);
      await store.hapus('');

      expect(File(path).existsSync(), isFalse);
    });
  });

  group('QrisStore', () {
    late AppDatabase database;

    setUp(() => database = AppDatabase.inMemory());
    tearDown(() => database.close());

    test('kosong sampai gambar disimpan, lalu bisa dihapus lagi', () async {
      final qris = QrisStore(database);
      expect(await qris.baca(), isNull);

      await qris.simpan('/tmp/qris.png');
      expect(await qris.baca(), '/tmp/qris.png');

      await qris.hapus();
      expect(await qris.baca(), isNull);
    });
  });

  group('Pengaturan', () {
    late AppDatabase database;

    setUp(() async {
      database = AppDatabase.inMemory();
      await TokoStore(
        database,
      ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
      await PinStore(database).simpan('1234');
    });
    tearDown(() => database.close());

    Future<void> bukaAplikasi(WidgetTester tester) async {
      await tester.pumpWidget(
        KasirApp(
          database: database,
          clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
          overrides: [
            pemilihGambarProvider.overrideWithValue(pemilih),
            gambarStoreProvider.overrideWithValue(gambar),
          ],
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> bukaPengaturan(WidgetTester tester) async {
      await tester.tap(find.text('Pengaturan').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('pin-input')), '1234');
      await tester.tap(find.byKey(const Key('pin-buka')));
      await tester.pumpAndSettle();
    }

    /// Tombol QRIS ada di bawah daftar Pengaturan: ListView membangun isinya
    /// malas, jadi harus digulir dulu sebelum bisa disentuh.
    Future<void> tekan(WidgetTester tester, String kunci) async {
      final tombol = find.byKey(Key(kunci));
      await tester.scrollUntilVisible(
        tombol,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(tombol);
      await tester.pumpAndSettle();
    }

    testWidgets('memilih gambar QR menyimpannya dan menampilkannya', (
      tester,
    ) async {
      await bukaAplikasi(tester);
      await bukaPengaturan(tester);
      expect(find.byKey(const Key('qris-belum-ada')), findsOneWidget);

      await tekan(tester, 'qris-pilih');

      expect(gambar.disimpan, 1);
      expect(find.byKey(const Key('qris-gambar')), findsOneWidget);
      expect(find.byKey(const Key('qris-belum-ada')), findsNothing);
      expect(
        await database.getSetting(SettingKeys.gambarQris),
        gambarContoh.path,
      );

      await tutupAplikasi(tester);
    });

    testWidgets('membatalkan pilihan tidak menyimpan gambar apa pun', (
      tester,
    ) async {
      pemilih.berkas = null;

      await bukaAplikasi(tester);
      await bukaPengaturan(tester);
      await tekan(tester, 'qris-pilih');

      expect(pemilih.dipanggil, 1);
      expect(gambar.disimpan, 0);
      expect(find.byKey(const Key('qris-belum-ada')), findsOneWidget);
      expect(await database.getSetting(SettingKeys.gambarQris), isNull);

      await tutupAplikasi(tester);
    });

    testWidgets('Hapus membuang rujukan gambar dan berkasnya', (tester) async {
      await QrisStore(database).simpan(gambarContoh.path);

      await bukaAplikasi(tester);
      await bukaPengaturan(tester);
      expect(find.byKey(const Key('qris-gambar')), findsOneWidget);

      await tekan(tester, 'qris-hapus');

      expect(gambar.dihapus, 1);
      expect(find.byKey(const Key('qris-belum-ada')), findsOneWidget);
      expect(await database.getSetting(SettingKeys.gambarQris), '');

      await tutupAplikasi(tester);
    });
  });

  group('Pembayaran QRIS', () {
    late AppDatabase database;
    late int kopiId;

    setUp(() async {
      database = AppDatabase.inMemory();
      await TokoStore(
        database,
      ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
      await PinStore(database).simpan('1234');
      kopiId = await ProdukStore(
        database,
      ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
      await StokStore(database).tambahStok(
        kopiId,
        jumlahMili: 10000,
        waktu: DateTime(2026, 10, 17, 9),
      );
    });
    tearDown(() => database.close());

    Future<void> bukaKasirSampaiBayar(WidgetTester tester) async {
      await tester.pumpWidget(
        KasirApp(
          database: database,
          clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
          overrides: [
            pemilihGambarProvider.overrideWithValue(pemilih),
            gambarStoreProvider.overrideWithValue(gambar),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kasir').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('kasir-produk-$kopiId')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('kasir-bayar')));
      await tester.pumpAndSettle();
    }

    Future<void> pilihQris(WidgetTester tester) async {
      await tester.tap(find.text('QRIS'));
      await tester.pumpAndSettle();
    }

    testWidgets('gambar QR tampil saat kasir memilih QRIS', (tester) async {
      await QrisStore(database).simpan(gambarContoh.path);
      await bukaKasirSampaiBayar(tester);

      // Tunai tidak menampilkan gambar QR sama sekali.
      expect(find.byKey(const Key('bayar-gambar-qris')), findsNothing);
      expect(find.byKey(const Key('bayar-kembalian')), findsOneWidget);

      await pilihQris(tester);

      expect(find.byKey(const Key('bayar-gambar-qris')), findsOneWidget);
      expect(find.byKey(const Key('bayar-uang-diterima')), findsNothing);
      expect(find.byKey(const Key('bayar-kembalian')), findsNothing);

      await tutupAplikasi(tester);
    });

    testWidgets('tanpa gambar QR kasir diberi pesan, Transaksi tetap jalan', (
      tester,
    ) async {
      await bukaKasirSampaiBayar(tester);
      await pilihQris(tester);

      expect(find.byKey(const Key('bayar-qris-kosong')), findsOneWidget);
      expect(find.byKey(const Key('bayar-gambar-qris')), findsNothing);

      await tester.tap(find.byKey(const Key('bayar-simpan')));
      await tester.pumpAndSettle();

      expect(find.text('Transaksi TRX-20261017-001 tersimpan'), findsOneWidget);
      expect(find.text('Keranjang masih kosong'), findsOneWidget);

      await tutupAplikasi(tester);
    });

    testWidgets('Transaksi QRIS tersimpan tanpa uang diterima dan Kembalian', (
      tester,
    ) async {
      await bukaKasirSampaiBayar(tester);
      await pilihQris(tester);
      await tester.tap(find.byKey(const Key('bayar-simpan')));
      await tester.pumpAndSettle();

      final tersimpan = await database.select(database.transaksi).getSingle();
      expect(tersimpan.metodeBayar, MetodeBayar.qris);
      expect(tersimpan.total, 15000);
      expect(tersimpan.uangDiterima, isNull);
      expect(tersimpan.kembalian, isNull);

      await tutupAplikasi(tester);
    });
  });
}
