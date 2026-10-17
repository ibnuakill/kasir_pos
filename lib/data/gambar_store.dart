import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Menyimpan gambar milik aplikasi sebagai berkas di folder data aplikasi.
/// Database hanya menyimpan rujukan path-nya, bukan isi gambarnya.
class GambarStore {
  GambarStore(this._folder);

  /// Folder `gambar/` di dalam folder data aplikasi.
  GambarStore.aplikasi() : _folder = _folderAplikasi;

  final Future<Directory> Function() _folder;

  static Future<Directory> _folderAplikasi() async {
    final dir = await getApplicationSupportDirectory();
    return Directory(p.join(dir.path, 'gambar'));
  }

  /// Menyalin [sumber] menjadi `<nama>.<ekstensi>` lalu mengembalikan path
  /// berkas hasil salinan.
  ///
  /// Berkas lama dengan [nama] yang sama dibuang lebih dulu — termasuk yang
  /// ekstensinya berbeda — supaya mengganti gambar menggantikan, bukan
  /// menumpuk berkas baru.
  Future<String> simpanDari(String sumber, {required String nama}) async {
    final folder = await _folder();
    await folder.create(recursive: true);
    await _hapusBernama(folder, nama);

    final ekstensi = p.extension(sumber).isEmpty
        ? '.png'
        : p.extension(sumber).toLowerCase();
    final tujuan = File(p.join(folder.path, '$nama$ekstensi'));
    await File(sumber).copy(tujuan.path);
    return tujuan.path;
  }

  /// Menghapus satu berkas gambar. Path kosong atau berkas yang sudah tidak
  /// ada bukan kesalahan.
  Future<void> hapus(String? path) async {
    if (path == null || path.isEmpty) return;
    final berkas = File(path);
    if (await berkas.exists()) await berkas.delete();
  }

  /// Semua berkas gambar yang tersimpan, untuk dikemas ke dalam Backup.
  Future<List<File>> semua() async {
    final folder = await _folder();
    if (!await folder.exists()) return const [];
    return [
      await for (final berkas in folder.list())
        if (berkas is File) berkas,
    ];
  }

  /// Menghapus semua berkas gambar. Dipakai Impor Backup supaya tidak ada
  /// gambar lama yang tertinggal saat seluruh data ditimpa.
  Future<void> bersihkan() async {
    final folder = await _folder();
    if (!await folder.exists()) return;
    await for (final berkas in folder.list()) {
      if (berkas is File) await berkas.delete();
    }
  }

  /// Folder tempat gambar disimpan. Dipakai Backup untuk menaruh kembali
  /// gambar hasil Impor.
  Future<Directory> folder() => _folder();

  Future<void> _hapusBernama(Directory folder, String nama) async {
    if (!await folder.exists()) return;
    await for (final lama in folder.list()) {
      if (lama is File && p.basenameWithoutExtension(lama.path) == nama) {
        await lama.delete();
      }
    }
  }
}
