import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/pemilih_gambar.dart';
import 'package:kasir/core/pembagi.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:kasir/data/keranjang_store.dart';
import 'package:kasir/data/qris_store.dart';
import 'package:kasir/data/toko_store.dart';

/// Database aplikasi. Selalu diisi oleh [KasirApp], sehingga tidak ada bagian
/// aplikasi yang membuka database sendiri.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('databaseProvider harus diisi oleh KasirApp'),
);

/// Sumber waktu aplikasi. Selalu diisi oleh [KasirApp].
final clockProvider = Provider<Clock>(
  (ref) => throw StateError('clockProvider harus diisi oleh KasirApp'),
);

/// Data Toko yang tersimpan, atau null bila wizard belum pernah dijalankan.
final tokoProvider = FutureProvider<Toko?>(
  (ref) => TokoStore(ref.watch(databaseProvider)).baca(),
);

/// Penyimpanan gambar milik aplikasi. Di test diarahkan ke folder sementara.
final gambarStoreProvider = Provider<GambarStore>(
  (ref) => GambarStore.aplikasi(),
);

/// Pintu masuk gambar dari galeri atau kamera. Di test diganti pemilih palsu.
final pemilihGambarProvider = Provider<PemilihGambar>(
  (ref) => const PemilihGambarPerangkat(),
);

/// Lembar berbagi sistem. Di test diganti pembagi palsu supaya tidak ada
/// lembar berbagi yang benar-benar terbuka.
final pembagiProvider = Provider<Pembagi>((ref) => const PembagiSistem());

/// Penyimpanan Keranjang yang sedang disusun, supaya bertahan saat aplikasi
/// ditutup (user story 40, 41).
final keranjangStoreProvider = Provider<KeranjangStore>(
  (ref) => KeranjangStore(ref.watch(databaseProvider)),
);

/// Path gambar QRIS toko, atau null bila belum diatur.
final gambarQrisProvider = FutureProvider<String?>(
  (ref) => QrisStore(ref.watch(databaseProvider)).baca(),
);
