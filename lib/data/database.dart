import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kasir/core/diskon.dart';
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

  /// Path berkas Foto Produk di penyimpanan aplikasi, bukan isi gambarnya.
  /// Null berarti Produk ini belum punya foto dan katalog memakai penanda
  /// pengganti.
  TextColumn get foto => text().nullable()();
}

/// Jenis pergerakan Stok. Disimpan sebagai teks supaya Backup tetap terbaca
/// manusia dan urutan enum tidak pernah menjadi bagian dari data.
enum JenisPergerakan { tambahStok, koreksiStok, penjualan, pembatalan }

/// Catatan pergerakan Stok. Stok itu sendiri tidak disimpan di mana pun: ia
/// adalah penjumlahan kolom [jumlahMili] milik satu Produk (ADR-0003).
class PergerakanStok extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produkId => integer().references(Produk, #id)();

  TextColumn get jenis => textEnum<JenisPergerakan>()();

  /// Perubahan berskala seribu: 2500 berarti 2,5. Negatif untuk Stok keluar.
  IntColumn get jumlahMili => integer()();

  DateTimeColumn get waktu => dateTime()();
}

/// Cara pembeli melunasi Transaksi. Versi ini hanya Tunai dan QRIS.
enum MetodeBayar { tunai, qris }

/// Satu Transaksi yang sudah tersimpan.
///
/// Nomor, waktu, dan seluruh angka uangnya dibekukan di sini supaya Struk lama
/// tetap terbaca walau Harga Katalog berubah kemudian.
class Transaksi extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `TRX-<YYYYMMDD>-<NNN>`; unik sebagai jaring pengaman terakhir kalau
  /// penghitung urutan pernah salah.
  TextColumn get nomor => text().unique()();

  DateTimeColumn get waktu => dateTime()();
  TextColumn get metodeBayar => textEnum<MetodeBayar>()();

  IntColumn get subtotal => integer()();

  /// Diskon disimpan sebagai bentuk aslinya, bukan hanya hasil potongannya,
  /// supaya Struk bisa menulis "Diskon 10%".
  TextColumn get diskonJenis => textEnum<JenisDiskon>().nullable()();
  IntColumn get diskonNilai => integer().nullable()();
  IntColumn get potongan => integer()();

  IntColumn get total => integer()();

  /// Hanya terisi untuk pembayaran Tunai; QRIS tidak punya Kembalian.
  IntColumn get uangDiterima => integer().nullable()();
  IntColumn get kembalian => integer().nullable()();

  /// Transaksi Batal tidak dihapus: jejak kesalahannya harus tetap ada, dan
  /// Omzet tidak menghitungnya (user story 65, 66).
  BoolColumn get batal => boolean().withDefault(const Constant(false))();
  TextColumn get alasanBatal => text().nullable()();
  DateTimeColumn get waktuBatal => dateTime().nullable()();
}

/// Baris barang yang terjual. Nama, Satuan, dan harga disalin saat Transaksi
/// tersimpan, jadi riwayat tidak ikut berubah ketika katalog disunting
/// (user story 17 dan 36).
class BarisTransaksi extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transaksiId => integer().references(Transaksi, #id)();
  IntColumn get produkId => integer().references(Produk, #id)();
  TextColumn get namaProduk => text()();
  TextColumn get satuan => text()();
  IntColumn get hargaSatuan => integer()();
  IntColumn get kuantitasMili => integer()();
  IntColumn get subtotal => integer()();
}

@DriftDatabase(
  tables: [
    AppSettings,
    Kategori,
    Produk,
    PergerakanStok,
    Transaksi,
    BarisTransaksi,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Database sekali pakai di memori, tanpa menyentuh penyimpanan perangkat.
  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 6;

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
      if (from < 3) {
        await m.createTable(pergerakanStok);
      }
      if (from < 4) {
        await m.createTable(transaksi);
        await m.createTable(barisTransaksi);
      }
      // Kolom baru hanya ditambahkan kalau tabelnya sudah ada. Kalau tabelnya
      // baru dibuat di langkah `from < 2`, kolomnya sudah ikut terpasang.
      if (from >= 2 && from < 5) {
        await m.addColumn(produk, produk.foto);
      }
      if (from >= 4 && from < 6) {
        await m.addColumn(transaksi, transaksi.batal);
        await m.addColumn(transaksi, transaksi.alasanBatal);
        await m.addColumn(transaksi, transaksi.waktuBatal);
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
