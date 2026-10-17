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

/// Pengelompokan Produk untuk menyusun katalog di layar kasir.
class Kategori extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();
}

/// Barang yang dijual. Tidak pernah dihapus, hanya dinonaktifkan (ADR-0004).
class Produk extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();

  /// Harga jual dalam rupiah bulat, dipakai apa adanya saat menjual.
  IntColumn get hargaKatalog => integer()();

  /// Satuan bebas milik toko; satu Produk hanya punya satu Satuan (ADR-0005).
  TextColumn get satuan => text()();

  BoolColumn get bolehPecahan =>
      boolean().withDefault(const Constant(false))();

  /// Boleh kosong: katalog bisa diisi sebelum sempat dirapikan per Kategori.
  IntColumn get kategoriId =>
      integer().nullable().references(Kategori, #id)();

  BoolColumn get aktif => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [AppSettings, Kategori, Produk])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Database sekali pakai di memori, tanpa menyentuh penyimpanan perangkat.
  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Jalur migrasi bernomor. Setiap versi skema baru menambah satu langkah
      // di sini, sehingga data toko tidak pernah hilang karena bentuk data
      // berubah. Versi 1 belum punya langkah apa pun.
      if (from < 2) {
        await m.createTable(kategori);
        await m.createTable(produk);
      }
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
