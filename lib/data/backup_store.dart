import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:kasir/data/setting_keys.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Berkas yang dipilih bukan Backup yang bisa dipulihkan. Pesannya sudah siap
/// ditampilkan ke kasir (user story 75).
class BackupTidakSahException implements Exception {
  const BackupTidakSahException(this.pesan);

  final String pesan;

  @override
  String toString() => pesan;
}

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

  /// Membaca `backup.json`. Bentuk yang tidak dikenal ditolak di sini, sebelum
  /// satu baris pun menyentuh database.
  factory IsiBackup.dariJson(Object? json) {
    if (json is! Map) {
      throw const BackupTidakSahException('Berkas ini bukan Backup kasir.');
    }

    final versi = json['versi'];
    if (versi is! int || versi <= 0) {
      throw const BackupTidakSahException('Berkas ini bukan Backup kasir.');
    }
    if (versi > versiSekarang) {
      throw const BackupTidakSahException(
        'Backup dibuat aplikasi versi lebih baru. Perbarui aplikasi dulu.',
      );
    }

    final tabel = json['tabel'];
    if (tabel is! Map) {
      throw const BackupTidakSahException('Backup tidak memuat data tabel.');
    }

    final hasil = <String, List<Map<String, Object?>>>{};
    for (final nama in urutanTabel) {
      final baris = tabel[nama];
      if (baris is! List) {
        throw BackupTidakSahException('Backup tidak lengkap: $nama tidak ada.');
      }
      final dibaca = <Map<String, Object?>>[];
      for (final satu in baris) {
        if (satu is! Map) {
          throw BackupTidakSahException('Isi tabel $nama tidak dikenali.');
        }
        dibaca.add(Map<String, Object?>.from(satu));
      }
      hasil[nama] = dibaca;
    }

    final dibuat = DateTime.tryParse('${json['dibuat']}');
    if (dibuat == null) {
      throw const BackupTidakSahException('Tanggal Backup tidak dikenali.');
    }

    return IsiBackup(versi: versi, dibuat: dibuat, tabel: hasil);
  }

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

/// Backup toko: membuat, membaca tanggalnya, dan memulihkannya.
///
/// Dibuat sebagai antarmuka supaya layar Pengaturan bisa diuji tanpa menulis
/// berkas sungguhan: penulisan berkas nyata tidak berjalan di jam palsu milik
/// widget test.
abstract interface class BackupKasir {
  Future<File> ekspor({required DateTime waktu});

  Future<DateTime?> terakhir();

  /// Menimpa seluruh data dengan isi Backup di [path] (user story 74, 75).
  Future<void> pulihkan(String path);
}

/// Membuat dan memulihkan Backup ZIP dari seluruh data toko.
///
/// Ekspor hanya membaca: tidak ada baris yang dihapus atau diubah, kecuali
/// catatan tanggal Backup terakhir (user story 76).
class BackupStore implements BackupKasir {
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
      tabel: {
        for (final tabel in IsiBackup.urutanTabel) tabel: await _baris(tabel),
      },
    );

    final arsip = Archive();
    final json = utf8.encode(jsonEncode(isi.keJson()));
    arsip.addFile(ArchiveFile(namaBerkasJson, json.length, json));

    for (final gambar in await _gambar.semua()) {
      final bytes = await gambar.readAsBytes();
      arsip.addFile(
        ArchiveFile(
          '$folderGambar/${p.basename(gambar.path)}',
          bytes.length,
          bytes,
        ),
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

  /// Memulihkan seluruh data dari Backup, menimpa apa pun yang sedang ada.
  ///
  /// Urutannya: berkas diperiksa dulu sampai utuh, gambar ditaruh, baru database
  /// ditimpa dalam satu transaksi. Berkas yang tidak sah berhenti sebelum ada
  /// yang berubah, jadi data toko yang sedang berjalan tidak ikut rusak.
  @override
  Future<void> pulihkan(String path) async {
    final berkas = File(path);
    if (!await berkas.exists()) {
      throw const BackupTidakSahException('Berkas Backup tidak ditemukan.');
    }

    final arsip = _bukaZip(await berkas.readAsBytes());
    final isi = _bacaJson(arsip);

    final folder = await _gambar.folder();
    await folder.create(recursive: true);

    // Gambar ditaruh lebih dulu supaya baris database tidak pernah menunjuk
    // berkas yang belum ada.
    await _gambar.bersihkan();
    for (final satu in arsip.files) {
      if (!satu.isFile) continue;
      if (!satu.name.startsWith('$folderGambar/')) continue;
      final tujuan = File(p.join(folder.path, p.basename(satu.name)));
      await tujuan.writeAsBytes(satu.content as List<int>, flush: true);
    }

    await _db.transaction(() async {
      // Dihapus dari tabel paling hilir, dimasukkan dari paling hulu.
      for (final tabel in IsiBackup.urutanTabel.reversed) {
        await _db.customStatement('DELETE FROM $tabel');
      }
      for (final tabel in IsiBackup.urutanTabel) {
        for (final baris in isi.tabel[tabel]!) {
          await _sisip(tabel, _pathBaru(tabel, baris, folder.path));
        }
      }
    });
  }

  /// `kasir-backup-20261017-0930.zip` — tanggal dan jam lokal, supaya berkas
  /// yang menumpuk di drive bisa dibedakan tanpa membukanya.
  static String namaBerkas(DateTime waktu) {
    String dua(int angka) => angka.toString().padLeft(2, '0');
    return 'kasir-backup-${waktu.year}${dua(waktu.month)}${dua(waktu.day)}'
        '-${dua(waktu.hour)}${dua(waktu.minute)}.zip';
  }

  Archive _bukaZip(List<int> bytes) {
    try {
      return ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const BackupTidakSahException('Berkas ini bukan Backup kasir.');
    }
  }

  IsiBackup _bacaJson(Archive arsip) {
    ArchiveFile? berkas;
    for (final satu in arsip.files) {
      if (satu.name == namaBerkasJson) berkas = satu;
    }
    if (berkas == null) {
      throw const BackupTidakSahException('Berkas ini bukan Backup kasir.');
    }

    try {
      return IsiBackup.dariJson(jsonDecode(utf8.decode(berkas.content)));
    } on BackupTidakSahException {
      rethrow;
    } on Object {
      throw const BackupTidakSahException('Isi Backup tidak bisa dibaca.');
    }
  }

  /// Foto Produk dan gambar QRIS disimpan sebagai path mutlak, dan path itu
  /// berbeda di HP lain. Yang dipertahankan hanya nama berkasnya, lalu
  /// diarahkan ke folder gambar perangkat ini.
  Map<String, Object?> _pathBaru(
    String tabel,
    Map<String, Object?> baris,
    String folder,
  ) {
    final hasil = Map<String, Object?>.from(baris);
    if (tabel == 'produk') {
      final foto = hasil['foto'];
      if (foto is String && foto.isNotEmpty) {
        hasil['foto'] = p.join(folder, p.basename(foto));
      }
    }
    if (tabel == 'app_settings' && hasil['key'] == SettingKeys.gambarQris) {
      final qris = hasil['value'];
      if (qris is String && qris.isNotEmpty) {
        hasil['value'] = p.join(folder, p.basename(qris));
      }
    }
    return hasil;
  }

  Future<void> _sisip(String tabel, Map<String, Object?> baris) async {
    if (baris.isEmpty) return;
    final kolom = baris.keys.toList();
    final tanda = List.filled(kolom.length, '?').join(', ');
    await _db.customStatement(
      'INSERT INTO $tabel (${kolom.join(', ')}) VALUES ($tanda)',
      [for (final satu in kolom) baris[satu]],
    );
  }

  Future<List<Map<String, Object?>>> _baris(String tabel) async {
    final hasil = await _db.customSelect('SELECT * FROM $tabel').get();
    return [for (final baris in hasil) Map<String, Object?>.from(baris.data)];
  }
}
