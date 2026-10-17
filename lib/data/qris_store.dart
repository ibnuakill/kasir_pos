import 'package:kasir/data/database.dart';
import 'package:kasir/data/setting_keys.dart';

/// Rujukan gambar QRIS milik toko. Satu toko punya satu gambar statis yang
/// ditampilkan saat kasir memilih QRIS.
///
/// Yang disimpan hanya path-nya. Kalau berkasnya hilang dari penyimpanan,
/// layar menampilkan pengganti lewat `errorBuilder` gambar, bukan kotak rusak.
class QrisStore {
  const QrisStore(this._database);

  final AppDatabase _database;

  /// Null berarti gambar QR belum pernah diunggah.
  Future<String?> baca() async {
    final path = await _database.getSetting(SettingKeys.gambarQris);
    if (path == null || path.isEmpty) return null;
    return path;
  }

  Future<void> simpan(String path) =>
      _database.setSetting(SettingKeys.gambarQris, path);

  Future<void> hapus() => _database.setSetting(SettingKeys.gambarQris, '');
}
