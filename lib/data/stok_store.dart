import 'package:drift/drift.dart';

import 'database.dart';

/// Stok tidak pernah ditimpa. Setiap perubahan adalah satu baris catatan, dan
/// angka Stok yang tampil selalu hasil penjumlahan catatan itu (ADR-0003).
class StokStore {
  const StokStore(this._db);

  final AppDatabase _db;

  /// Stok seluruh Produk sekaligus, untuk daftar katalog. Dijumlahkan di
  /// database, bukan dengan memuat semua catatan ke memori.
  Stream<Map<int, int>> watchTotalPerProduk() {
    final total = _db.pergerakanStok.jumlahMili.sum();
    final query = _db.selectOnly(_db.pergerakanStok)
      ..addColumns([_db.pergerakanStok.produkId, total])
      ..groupBy([_db.pergerakanStok.produkId]);

    return query.watch().map(
      (baris) => {
        for (final b in baris)
          b.read(_db.pergerakanStok.produkId)!: b.read(total) ?? 0,
      },
    );
  }

  /// Riwayat pergerakan satu Produk, terbaru di atas.
  Stream<List<PergerakanStokData>> watchPergerakan(int produkId) {
    final query = _db.select(_db.pergerakanStok)
      ..where((t) => t.produkId.equals(produkId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.waktu, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<void> tambahStok(
    int produkId, {
    required int jumlahMili,
    required DateTime waktu,
  }) async {
    if (jumlahMili <= 0) {
      throw ArgumentError.value(
        jumlahMili,
        'jumlahMili',
        'Tambah Stok harus lebih dari nol',
      );
    }

    await _db
        .into(_db.pergerakanStok)
        .insert(
          PergerakanStokCompanion.insert(
            produkId: produkId,
            jenis: JenisPergerakan.tambahStok,
            jumlahMili: jumlahMili,
            waktu: waktu,
          ),
        );
  }

  /// Menyesuaikan Stok ke angka hasil hitung fisik. Yang dicatat adalah
  /// selisihnya, jadi catatan lama tetap utuh dan angkanya tetap bisa
  /// dipertanggungjawabkan.
  Future<void> koreksiStok(
    int produkId, {
    required int stokBaruMili,
    required DateTime waktu,
  }) async {
    if (stokBaruMili < 0) {
      throw ArgumentError.value(
        stokBaruMili,
        'stokBaruMili',
        'Stok tidak boleh negatif',
      );
    }

    await _db.transaction(() async {
      final selisih = stokBaruMili - await _stokSekarang(produkId);
      if (selisih == 0) return;

      await _db
          .into(_db.pergerakanStok)
          .insert(
            PergerakanStokCompanion.insert(
              produkId: produkId,
              jenis: JenisPergerakan.koreksiStok,
              jumlahMili: selisih,
              waktu: waktu,
            ),
          );
    });
  }

  Future<int> _stokSekarang(int produkId) async {
    final total = _db.pergerakanStok.jumlahMili.sum();
    final query = _db.selectOnly(_db.pergerakanStok)
      ..addColumns([total])
      ..where(_db.pergerakanStok.produkId.equals(produkId));
    final baris = await query.getSingle();
    return baris.read(total) ?? 0;
  }
}
