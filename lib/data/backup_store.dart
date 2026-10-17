import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Isi berkas `backup.json` di dalam Backup ZIP.
///
/// Tabel disimpan apa adanya sebagai baris-baris JSON (nama kolom sama dengan
/// nama kolom database), bukan sebagai kelas-kelas Dart: Backup harus bisa
/// memulihkan **seluruh** data, termasuk kolom yang ditambahkan kemudian, tanpa
/// ada kolom yang terlupa dipetakan satu per satu. Berkas gambar tidak ikut di
/// sini; ia menjadi berkas terpisah di dalam ZIP yang sama.
class IsiBackup {
  const IsiBackup({
    required this.versi,
    required this.dibuat,
    required this.tabel,
  });

  /// Versi bentuk Backup. Naik kalau bentuknya berubah dan Impor perlu tahu.
  static const versiSekarang = 1;

  /// Urutan tabel mengikuti ketergantungan kunci asing, supaya Impor bisa
  /// memasukkan baris dari atas ke bawah tanpa melanggar rujukan.
  static const urutanTabel = [
    'app_settings',
    'kategori',
    'produk',
    'pergerakan_stok',
    'transaksi',
    'baris_transaksi',
  ];

  final int versi;
  final DateTime dibuat;
  final Map<String, List<Map<String, Object?>>> tabel;

  Map<String, Object?> keJson() => {
    'versi': versi,
    'dibuat': dibuat.toIso8601String(),
    'tabel': tabel,
  };
}

/// Pembuat Backup. Dibuat sebagai antarmuka supaya layar Pengaturan bisa diuji
/// tanpa menulis berkas sungguhan: penulisan berkas nyata tidak berjalan di jam
/// palsu milik widget test.
abstract interface class PembuatBackup {
  Future<File> ekspor({required DateTime waktu});

  Future<DateTime?> terakhir();
}

/// Membuat Backup ZIP dari seluruh data toko (user story 71, 72).
///
/// Ekspor hanya membaca: tidak ada baris yang dihapus atau diubah, kecuali
/// catatan tanggal Backup terakhir (user story 76).
class BackupStore implements PembuatBackup {
  BackupStore(this._db, this._gambar, {Future<Directory> Function()? folder})
    : _folder = folder ?? getTemporaryDirectory;

  /// Kunci `app_settings` untuk tanggal Backup terakhir yang berhasil dibuat.
  static const kunciTerakhir = 'backup.terakhir';

  static const namaBerkasJson = 'backup.json';
  static const folderGambar = 'gambar';

  final AppDatabase _db;
  final GambarStore _gambar;
  final Future<Directory> Function() _folder;

  /// Mengemas seluruh data menjadi satu berkas ZIP dan mengembalikan berkasnya.
  @override
  Future<File> ekspor({required DateTime waktu}) async {
    final isi = IsiBackup(
      versi: IsiBackup.versiSekarang,
      dibuat: waktu,
      tabel: {for (final tabel in IsiBackup.urutanTabel) tabel: await _baris(tabel)},
    );

    final arsip = Archive();
    final json = utf8.encode(jsonEncode(isi.keJson()));
    arsip.addFile(ArchiveFile(namaBerkasJson, json.length, json));

    for (final gambar in await _gambar.semua()) {
      final bytes = await gambar.readAsBytes();
      arsip.addFile(
        ArchiveFile('$folderGambar/${p.basename(gambar.path)}', bytes.length, bytes),
      );
    }

    final folder = await _folder();
    await folder.create(recursive: true);
    final berkas = File(p.join(folder.path, namaBerkas(waktu)));
    await berkas.writeAsBytes(ZipEncoder().encode(arsip), flush: true);

    await _db.setSetting(kunciTerakhir, waktu.toIso8601String());
    return berkas;
  }

  /// Tanggal Backup terakhir, atau null bila belum pernah (user story 76).
  @override
  Future<DateTime?> terakhir() async {
    final teks = await _db.getSetting(kunciTerakhir);
    return teks == null ? null : DateTime.tryParse(teks);
  }

  /// `kasir-backup-20261017-0930.zip` — tanggal dan jam lokal, supaya berkas
  /// yang menumpuk di drive bisa dibedakan tanpa membukanya.
  static String namaBerkas(DateTime waktu) {
    String dua(int angka) => angka.toString().padLeft(2, '0');
    return 'kasir-backup-${waktu.year}${dua(waktu.month)}${dua(waktu.day)}'
        '-${dua(waktu.hour)}${dua(waktu.minute)}.zip';
  }

  Future<List<Map<String, Object?>>> _baris(String tabel) async {
    final hasil = await _db.customSelect('SELECT * FROM $tabel').get();
    return [for (final baris in hasil) Map<String, Object?>.from(baris.data)];
  }
}
