import 'package:drift/drift.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/database.dart';

/// Laporan satu hari: daftar Transaksi beserta angka yang diturunkan darinya.
///
/// Omzet dan jumlah Transaksi sengaja dihitung dari daftar yang sama, bukan
/// query terpisah, supaya angka di atas dan daftar di bawah tidak mungkin
/// berbeda (user story 59, 67).
class LaporanHarian {
  const LaporanHarian({required this.tanggal, required this.transaksi});

  final DateTime tanggal;
  final List<TransaksiData> transaksi;

  int get omzet => transaksi.fold(0, (jumlah, satu) => jumlah + satu.total);
  int get jumlahTransaksi => transaksi.length;
  bool get kosong => transaksi.isEmpty;
}

/// Membaca Transaksi per hari kalender perangkat (user story 60, 61).
class LaporanStore {
  const LaporanStore(this._db);

  final AppDatabase _db;

  /// Transaksi pada satu hari, urut waktu. Batasnya [awalHari] sampai tepat
  /// sebelum tengah malam berikutnya, jadi Transaksi pukul 23:59 tetap masuk
  /// hari itu dan pukul 00:00 sudah masuk hari berikutnya.
  Stream<LaporanHarian> watchHarian(DateTime tanggal) {
    final mulai = awalHari(tanggal);
    final selesai = DateTime(mulai.year, mulai.month, mulai.day + 1);

    final query = _db.select(_db.transaksi)
      ..where(
        (t) =>
            t.waktu.isBiggerOrEqualValue(mulai) &
            t.waktu.isSmallerThanValue(selesai),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.waktu),
        (t) => OrderingTerm(expression: t.id),
      ]);

    return query.watch().map(
      (daftar) => LaporanHarian(tanggal: mulai, transaksi: daftar),
    );
  }
}
