import 'package:kasir/data/database.dart';
import 'package:kasir/data/setting_keys.dart';

/// Data Toko: nama dan alamat yang dicetak di bagian atas struk.
class Toko {
  const Toko({required this.nama, required this.alamat});

  final String nama;
  final String alamat;
}

/// Membaca dan menulis Data Toko.
class TokoStore {
  const TokoStore(this._database);

  final AppDatabase _database;

  /// Null berarti Data Toko belum pernah diisi, yaitu aplikasi masih baru.
  Future<Toko?> baca() async {
    final nama = await _database.getSetting(SettingKeys.namaToko);
    if (nama == null || nama.isEmpty) return null;
    final alamat = await _database.getSetting(SettingKeys.alamatToko) ?? '';
    return Toko(nama: nama, alamat: alamat);
  }

  Future<void> simpan(Toko toko) async {
    await _database.setSetting(SettingKeys.namaToko, toko.nama);
    await _database.setSetting(SettingKeys.alamatToko, toko.alamat);
  }
}
