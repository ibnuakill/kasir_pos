import 'package:kasir/core/pin.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/setting_keys.dart';

/// Satu-satunya jalan membaca dan menulis PIN.
class PinStore {
  const PinStore(this._database);

  final AppDatabase _database;

  Future<void> simpan(String pin) =>
      _database.setSetting(SettingKeys.pinHash, PinHash.buat(pin));

  Future<bool> cocok(String pin) async {
    final tersimpan = await _database.getSetting(SettingKeys.pinHash);
    if (tersimpan == null) return false;
    return PinHash.cocok(pin, tersimpan);
  }
}
