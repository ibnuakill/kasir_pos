import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/diskon.dart';
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

/// Isi Keranjang beserta Diskon yang menempel padanya. Diskon ikut di sini
/// supaya Subtotal, Diskon, dan Total tidak pernah saling bertentangan.
class IsiKeranjang {
  const IsiKeranjang({this.baris = const [], this.diskon});

  final List<BarisKeranjang> baris;
  final Diskon? diskon;

  int get subtotal => baris.fold(0, (total, satu) => total + satu.subtotal);
  int get potongan => hitungPotongan(subtotal, diskon);
  int get total => subtotal - potongan;
  int get jumlahBaris => baris.length;
  bool get kosong => baris.isEmpty;
}

/// Keranjang yang sedang disusun. Masih di memori pada tiket ini; tiket 14
/// yang memindahkannya ke database supaya bertahan saat aplikasi ditutup.
class Keranjang extends Notifier<IsiKeranjang> {
  @override
  IsiKeranjang build() => const IsiKeranjang();

  void tambah(ProdukData produk) {
    final posisi = state.baris.indexWhere(
      (baris) => baris.produk.id == produk.id,
    );
    if (posisi == -1) {
      state = IsiKeranjang(
        baris: [
          ...state.baris,
          BarisKeranjang(produk: produk, kuantitasMili: skalaKuantitas),
        ],
        diskon: state.diskon,
      );
      return;
    }

    final baris = state.baris[posisi];
    state = IsiKeranjang(
      baris: [...state.baris]
        ..[posisi] = baris.denganKuantitas(
          baris.kuantitasMili + skalaKuantitas,
        ),
      diskon: state.diskon,
    );
  }

  void ubahKuantitas(int produkId, int kuantitasMili) {
    state = IsiKeranjang(
      baris: [
        for (final baris in state.baris)
          if (baris.produk.id == produkId)
            baris.denganKuantitas(kuantitasMili)
          else
            baris,
      ],
      diskon: state.diskon,
    );
  }

  void hapus(int produkId) {
    final sisa = [
      for (final baris in state.baris)
        if (baris.produk.id != produkId) baris,
    ];
    // Keranjang kosong berarti transaksi baru: Diskon lama tidak boleh
    // menempel diam-diam pada belanja berikutnya.
    state = IsiKeranjang(baris: sisa, diskon: sisa.isEmpty ? null : state.diskon);
  }

  /// `null` berarti Diskon dihapus dan Total kembali sama dengan Subtotal.
  void pasangDiskon(Diskon? diskon) {
    state = IsiKeranjang(baris: state.baris, diskon: diskon);
  }
}

final keranjangProvider = NotifierProvider<Keranjang, IsiKeranjang>(
  Keranjang.new,
);
