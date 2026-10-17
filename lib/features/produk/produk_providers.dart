import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/kategori_store.dart';
import 'package:kasir/data/produk_store.dart';

final produkStoreProvider = Provider<ProdukStore>(
  (ref) => ProdukStore(ref.watch(databaseProvider)),
);

final kategoriStoreProvider = Provider<KategoriStore>(
  (ref) => KategoriStore(ref.watch(databaseProvider)),
);

final daftarProdukProvider = StreamProvider<List<ProdukData>>(
  (ref) => ref.watch(produkStoreProvider).watch(),
);

final daftarKategoriProvider = StreamProvider<List<KategoriData>>(
  (ref) => ref.watch(kategoriStoreProvider).watch(),
);
