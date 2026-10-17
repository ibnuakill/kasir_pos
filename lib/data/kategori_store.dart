import 'package:drift/drift.dart';
import 'package:kasir/data/database.dart';

/// Satu-satunya jalan membaca dan menulis Kategori.
class KategoriStore {
  const KategoriStore(this._db);

  final AppDatabase _db;

  Stream<List<KategoriData>> watch() {
    final query = _db.select(_db.kategori)
      ..orderBy([(t) => OrderingTerm(expression: t.nama.lower())]);
    return query.watch();
  }

  Future<int> tambah(String nama) {
    return _db
        .into(_db.kategori)
        .insert(KategoriCompanion.insert(nama: nama.trim()));
  }
}
