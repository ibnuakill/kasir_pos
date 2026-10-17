import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/stok_store.dart';

final stokStoreProvider = Provider<StokStore>(
  (ref) => StokStore(ref.watch(databaseProvider)),
);

/// Stok seluruh Produk, untuk daftar katalog.
final totalStokProvider = StreamProvider<Map<int, int>>(
  (ref) => ref.watch(stokStoreProvider).watchTotalPerProduk(),
);

/// Riwayat pergerakan satu Produk. `autoDispose` supaya membuka lalu menutup
/// banyak Produk tidak meninggalkan langganan database yang menganggur.
final pergerakanProvider =
    StreamProvider.autoDispose.family<List<PergerakanStokData>, int>(
      (ref, produkId) => ref.watch(stokStoreProvider).watchPergerakan(produkId),
    );
