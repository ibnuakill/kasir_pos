import 'package:drift/drift.dart';
import 'package:kasir/data/database.dart';

/// Satu-satunya jalan membaca dan menulis Produk.
///
/// Tidak ada `hapus`: Produk yang tidak dijual lagi dinonaktifkan, supaya
/// riwayat Transaksi yang menyebutnya tetap utuh (ADR-0004).
class ProdukStore {
  const ProdukStore(this._db);

  final AppDatabase _db;

  /// Seluruh Produk, urut nama. Penyaringan aktif/nonaktif dan pencarian
  /// dikerjakan di layar, bukan di query: katalog warung muat di memori, dan
  /// satu langganan tetap jauh lebih murah daripada satu langganan per kata
  /// pencarian.
  Stream<List<ProdukData>> watch() {
    final query = _db.select(_db.produk)
      ..orderBy([(t) => OrderingTerm(expression: t.nama.lower())]);
    return query.watch();
  }

  Future<ProdukData?> cari(int id) {
    return (_db.select(
      _db.produk,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> tambah({
    required String nama,
    required int hargaKatalog,
    required String satuan,
    bool bolehPecahan = false,
    int? kategoriId,
  }) {
    return _db.into(_db.produk).insert(
      ProdukCompanion.insert(
        nama: nama.trim(),
        hargaKatalog: hargaKatalog,
        satuan: satuan.trim(),
        bolehPecahan: Value(bolehPecahan),
        kategoriId: Value(kategoriId),
      ),
    );
  }

  Future<void> ubah(
    int id, {
    required String nama,
    required int hargaKatalog,
    required String satuan,
    required bool bolehPecahan,
    int? kategoriId,
  }) async {
    await (_db.update(_db.produk)..where((t) => t.id.equals(id))).write(
      ProdukCompanion(
        nama: Value(nama.trim()),
        hargaKatalog: Value(hargaKatalog),
        satuan: Value(satuan.trim()),
        bolehPecahan: Value(bolehPecahan),
        // Value(null) menulis NULL, bukan "jangan diubah": Kategori memang
        // boleh dilepas dari sebuah Produk.
        kategoriId: Value(kategoriId),
      ),
    );
  }

  Future<void> setAktif(int id, bool aktif) async {
    await (_db.update(_db.produk)..where((t) => t.id.equals(id))).write(
      ProdukCompanion(aktif: Value(aktif)),
    );
  }
}
