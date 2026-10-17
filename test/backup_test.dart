import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/pembagi.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/backup_store.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:kasir/data/kategori_store.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/qris_store.dart';
import 'package:kasir/data/setting_keys.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:path/path.dart' as p;

import 'bantuan.dart';

/// Pembagi palsu: mencatat berkas apa yang diserahkan ke lembar berbagi.
class _PembagiPalsu implements Pembagi {
  String? path;
  String? namaBerkas;
  String? teks;

  @override
  Future<void> bagikanGambar(
    dynamic png, {
    required String namaBerkas,
    required String teks,
  }) async {
    throw UnsupportedError('Backup tidak membagikan gambar');
  }

  @override
  Future<void> bagikanBerkas(
    String path, {
    required String namaBerkas,
    required String teks,
  }) async {
    this.path = path;
    this.namaBerkas = namaBerkas;
    this.teks = teks;
  }
}

/// Pembuat Backup palsu untuk menguji layar Pengaturan tanpa menulis berkas
/// sungguhan, yang tidak berjalan di jam palsu milik widget test.
class _BackupPalsu implements PembuatBackup {
  _BackupPalsu(this.berkas);

  final File berkas;
  DateTime? waktu;
  bool gagal = false;

  @override
  Future<File> ekspor({required DateTime waktu}) async {
    if (gagal) throw StateError('penyimpanan penuh');
    this.waktu = waktu;
    return berkas;
  }

  @override
  Future<DateTime?> terakhir() async => waktu;
}

void main() {
  late AppDatabase database;
  late Directory folderKerja;
  late GambarStore gambar;
  late BackupStore backup;
  late _PembagiPalsu pembagi;
  late _BackupPalsu backupPalsu;
  late int kopiId;

  setUp(() async {
    database = AppDatabase.inMemory();
    folderKerja = Directory.systemTemp.createTempSync('kasir_backup');
    gambar = GambarStore(
      () async => Directory(p.join(folderKerja.path, 'gambar')),
    );
    pembagi = _PembagiPalsu();
    backup = BackupStore(
      database,
      gambar,
      folder: () async => Directory(p.join(folderKerja.path, 'keluaran')),
    );
    backupPalsu = _BackupPalsu(
      File(p.join(folderKerja.path, 'kasir-backup-20261017-0930.zip'))
        ..writeAsBytesSync([80, 75, 3, 4]),
    );

    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');

    final kategori = await KategoriStore(database).tambah('Minuman');
    kopiId = await ProdukStore(database).tambah(
      nama: 'Kopi Bubuk',
      hargaKatalog: 15000,
      satuan: 'pcs',
      kategoriId: kategori,
    );
    await StokStore(
      database,
    ).tambahStok(kopiId, jumlahMili: 10000, waktu: DateTime(2026, 10, 17, 8));

    final produk = await ProdukStore(database).cari(kopiId);
    await TransaksiStore(database).simpan(
      waktu: DateTime(2026, 10, 17, 9),
      metodeBayar: MetodeBayar.tunai,
      baris: [BarisTerjual(produk: produk!, kuantitasMili: 2000)],
    );

    // Satu gambar QR toko dan satu Foto Produk, dua-duanya harus ikut.
    final sumber = File(p.join(folderKerja.path, 'qris.png'))
      ..writeAsBytesSync([137, 80, 78, 71, 1, 2, 3]);
    await QrisStore(
      database,
    ).simpan(await gambar.simpanDari(sumber.path, nama: 'qris'));
    await ProdukStore(
      database,
    ).setFoto(kopiId, await gambar.simpanDari(sumber.path, nama: 'produk-1'));
  });

  tearDown(() async {
    await database.close();
    try {
      folderKerja.deleteSync(recursive: true);
    } on FileSystemException {
      // Berkas hasil ekspor kadang masih dipegang sistem; folder sementara
      // dibiarkan, isinya tidak dipakai test lain.
    }
  });

  Archive bukaZip(String path) =>
      ZipDecoder().decodeBytes(File(path).readAsBytesSync());

  ArchiveFile cariBerkas(Archive arsip, String nama) =>
      arsip.files.firstWhere((berkas) => berkas.name == nama);

  Map<String, dynamic> bacaJson(Archive arsip) =>
      jsonDecode(
            utf8.decode(cariBerkas(arsip, BackupStore.namaBerkasJson).content),
          )
          as Map<String, dynamic>;

  group('isi Backup', () {
    late File berkas;

    setUp(() async {
      berkas = await backup.ekspor(waktu: DateTime(2026, 10, 17, 9, 30));
    });

    test('satu berkas ZIP dengan nama bertanggal', () {
      expect(p.basename(berkas.path), 'kasir-backup-20261017-0930.zip');
      expect(berkas.existsSync(), isTrue);
    });

    test('memuat seluruh tabel beserta isinya', () {
      final isi = bacaJson(bukaZip(berkas.path));

      expect(isi['versi'], IsiBackup.versiSekarang);
      expect((isi['tabel'] as Map).keys, containsAll(IsiBackup.urutanTabel));

      final produk = (isi['tabel']['produk'] as List).single as Map;
      expect(produk['nama'], 'Kopi Bubuk');
      expect(produk['harga_katalog'], 15000);

      final kategori = (isi['tabel']['kategori'] as List).single as Map;
      expect(kategori['nama'], 'Minuman');

      final transaksi = (isi['tabel']['transaksi'] as List).single as Map;
      expect(transaksi['nomor'], 'TRX-20261017-001');
      expect(transaksi['total'], 30000);

      final baris = (isi['tabel']['baris_transaksi'] as List).single as Map;
      expect(baris['nama_produk'], 'Kopi Bubuk');
      expect(baris['kuantitas_mili'], 2000);

      // Dua pergerakan: Tambah Stok lalu penjualan.
      expect(isi['tabel']['pergerakan_stok'] as List, hasLength(2));

      final pengaturan = {
        for (final baris in isi['tabel']['app_settings'] as List)
          (baris as Map)['key']: baris['value'],
      };
      expect(pengaturan[SettingKeys.namaToko], 'Warung Bu Sri');
      expect(pengaturan[SettingKeys.alamatToko], 'Jl. Melati 12');
      expect(pengaturan[SettingKeys.pinHash], isNotNull);
    });

    test('gambar QR toko dan Foto Produk ikut di dalam ZIP', () {
      final arsip = bukaZip(berkas.path);
      final nama = [for (final satu in arsip.files) satu.name];

      expect(nama, contains('${BackupStore.folderGambar}/qris.png'));
      expect(nama, contains('${BackupStore.folderGambar}/produk-1.png'));
      expect(
        cariBerkas(arsip, '${BackupStore.folderGambar}/qris.png').content,
        [137, 80, 78, 71, 1, 2, 3],
      );
    });

    test('mencatat tanggal Backup terakhir', () async {
      expect(await backup.terakhir(), DateTime(2026, 10, 17, 9, 30));
    });

    test('tidak mengubah isi database', () async {
      Future<Map<String, int>> hitung() async => {
        for (final tabel in IsiBackup.urutanTabel)
          tabel:
              (await database
                          .customSelect('SELECT COUNT(*) AS jumlah FROM $tabel')
                          .getSingle())
                      .data['jumlah']!
                  as int,
      };

      final sebelum = await hitung();
      await backup.ekspor(waktu: DateTime(2026, 10, 17, 10));
      final sesudah = await hitung();

      for (final tabel in IsiBackup.urutanTabel) {
        if (tabel == 'app_settings') continue;
        expect(sesudah[tabel], sebelum[tabel], reason: 'tabel $tabel berubah');
      }
    });

    test('setiap tabel di database ikut terbawa', () {
      // Penjaga: tabel baru yang lupa didaftarkan menggagalkan test ini, bukan
      // diam-diam hilang dari Backup.
      final diDatabase = [
        for (final tabel in database.allTables) tabel.actualTableName,
      ]..sort();
      final diBackup = [...IsiBackup.urutanTabel]..sort();

      expect(diBackup, diDatabase);
    });
  });

  group('layar Pengaturan', () {
    void layarTinggi(WidgetTester tester) {
      tester.view.physicalSize = const Size(500, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> bukaPengaturan(WidgetTester tester) async {
      layarTinggi(tester);
      await tester.pumpWidget(
        KasirApp(
          database: database,
          clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
          overrides: [
            gambarStoreProvider.overrideWithValue(gambar),
            pembagiProvider.overrideWithValue(pembagi),
            backupStoreProvider.overrideWithValue(backupPalsu),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pengaturan').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('pin-input')), '1234');
      await tester.tap(find.byKey(const Key('pin-buka')));
      await tester.pumpAndSettle();
    }

    testWidgets('tombol Ekspor Backup membagikan berkas ZIP', (tester) async {
      await bukaPengaturan(tester);
      await tester.tap(find.byKey(const Key('backup-ekspor')));
      await tester.pumpAndSettle();

      // Yang dibagikan berkas hasil ekspor, dengan nama berkasnya sendiri.
      expect(pembagi.path, backupPalsu.berkas.path);
      expect(pembagi.namaBerkas, 'kasir-backup-20261017-0930.zip');
      expect(backupPalsu.waktu, DateTime(2026, 10, 17, 9, 30));
      expect(find.text('Backup siap dibagikan'), findsOneWidget);

      await tutupAplikasi(tester);
    });

    testWidgets('tanggal Backup terakhir tampil dan diperbarui', (tester) async {
      await bukaPengaturan(tester);
      expect(
        tester.widget<Text>(find.byKey(const Key('backup-terakhir'))).data,
        'Belum pernah membuat Backup.',
      );

      await tester.tap(find.byKey(const Key('backup-ekspor')));
      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key('backup-terakhir'))).data,
        'Backup terakhir: 17/10/2026 09:30',
      );

      await tutupAplikasi(tester);
    });

    testWidgets('ekspor yang gagal memberi tahu kasir', (tester) async {
      backupPalsu.gagal = true;
      await bukaPengaturan(tester);
      await tester.tap(find.byKey(const Key('backup-ekspor')));
      await tester.pumpAndSettle();

      expect(find.text('Backup gagal dibuat'), findsOneWidget);
      expect(pembagi.path, isNull);
      expect(
        tester.widget<Text>(find.byKey(const Key('backup-terakhir'))).data,
        'Belum pernah membuat Backup.',
      );

      await tutupAplikasi(tester);
    });
  });
}
