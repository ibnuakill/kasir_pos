import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Penyimpanan kunci–nilai untuk hal yang bukan bagian dari katalog atau
/// transaksi: Data Toko, PIN, dan rujukan gambar QR.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Database sekali pakai di memori, tanpa menyentuh penyimpanan perangkat.
  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Jalur migrasi bernomor. Setiap versi skema baru menambah satu langkah
      // di sini, sehingga data toko tidak pernah hilang karena bentuk data
      // berubah. Versi 1 belum punya langkah apa pun.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }
}

/// Membuka database di penyimpanan aplikasi perangkat.
QueryExecutor openAppDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'kasir.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
