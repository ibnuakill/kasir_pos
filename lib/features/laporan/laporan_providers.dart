import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/laporan_store.dart';

final laporanStoreProvider = Provider<LaporanStore>(
  (ref) => LaporanStore(ref.watch(databaseProvider)),
);

/// Tanggal yang sedang dibuka di tab Laporan.
///
/// Awalnya hari ini menurut jam aplikasi, lalu bisa digeser pemilik toko
/// (user story 60). Disimpan sebagai awal hari supaya jamnya tidak pernah
/// membuat perbandingan tanggal meleset.
final tanggalLaporanProvider = StateProvider<DateTime>((ref) {
  final sekarang = ref.watch(clockProvider)();
  return awalHari(sekarang);
});

/// Laporan untuk tanggal yang sedang dibuka. Ikut berubah sendiri saat ada
/// Transaksi baru, karena sumbernya stream database.
final laporanHarianProvider = StreamProvider<LaporanHarian>((ref) {
  final tanggal = ref.watch(tanggalLaporanProvider);
  return ref.watch(laporanStoreProvider).watchHarian(tanggal);
});
