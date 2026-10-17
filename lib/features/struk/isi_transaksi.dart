import 'package:kasir/data/database.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';

/// Semua yang dibutuhkan untuk menampilkan satu Transaksi: Data Toko, kepala
/// Transaksi, dan barisnya.
class IsiTransaksi {
  const IsiTransaksi({
    required this.toko,
    required this.transaksi,
    required this.baris,
  });

  final Toko? toko;
  final TransaksiData transaksi;
  final List<BarisTransaksiData> baris;
}

/// Membaca satu Transaksi dari database berdasarkan id.
///
/// Dipakai bersama oleh pratinjau Struk setelah pembayaran dan oleh detail
/// Transaksi, supaya keduanya membaca dengan cara yang sama (user story 58).
Future<IsiTransaksi> muatTransaksi(AppDatabase database, int id) async {
  final transaksi = await TransaksiStore(database).cari(id);
  if (transaksi == null) {
    throw StateError('Transaksi tidak ditemukan');
  }

  return IsiTransaksi(
    toko: await TokoStore(database).baca(),
    transaksi: transaksi,
    baris: await TransaksiStore(database).barisDari(id),
  );
}
