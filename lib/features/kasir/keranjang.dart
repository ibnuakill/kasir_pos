import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/data/database.dart';

/// Satu baris Keranjang. Harga diambil dari Harga Katalog saat Produk
/// dimasukkan dan tidak bisa diubah dari layar kasir (user story 36).
class BarisKeranjang {
  const BarisKeranjang({required this.produk, required this.kuantitasMili});

  final ProdukData produk;
  final int kuantitasMili;

  /// Harga baris, dibulatkan ke rupiah terdekat karena uang tidak punya
  /// pecahan di aplikasi ini.
  int get subtotal =>
      (produk.hargaKatalog * kuantitasMili + skalaKuantitas ~/ 2) ~/
      skalaKuantitas;

  BarisKeranjang denganKuantitas(int mili) =>
      BarisKeranjang(produk: produk, kuantitasMili: mili);
}

/// Keranjang yang sedang disusun. Masih di memori pada tiket ini; tiket 14
/// yang memindahkannya ke database supaya bertahan saat aplikasi ditutup.
class Keranjang extends Notifier<List<BarisKeranjang>> {
  @override
  List<BarisKeranjang> build() => const [];

  void tambah(ProdukData produk) {
    final posisi = state.indexWhere((baris) => baris.produk.id == produk.id);
    if (posisi == -1) {
      state = [
        ...state,
        BarisKeranjang(produk: produk, kuantitasMili: skalaKuantitas),
      ];
      return;
    }

    final baris = state[posisi];
    state = [...state]
      ..[posisi] = baris.denganKuantitas(baris.kuantitasMili + skalaKuantitas);
  }

  void ubahKuantitas(int produkId, int kuantitasMili) {
    state = [
      for (final baris in state)
        if (baris.produk.id == produkId)
          baris.denganKuantitas(kuantitasMili)
        else
          baris,
    ];
  }

  void hapus(int produkId) {
    state = [
      for (final baris in state)
        if (baris.produk.id != produkId) baris,
    ];
  }
}

final keranjangProvider = NotifierProvider<Keranjang, List<BarisKeranjang>>(
  Keranjang.new,
);

int subtotalKeranjang(List<BarisKeranjang> baris) =>
    baris.fold(0, (total, satu) => total + satu.subtotal);
