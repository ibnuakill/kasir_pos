import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/keranjang_store.dart';

/// Satu baris Keranjang. Harga diambil dari Harga Katalog saat Produk
/// dimasukkan dan tidak bisa diubah dari layar kasir (user story 36).
class BarisKeranjang {
  const BarisKeranjang({required this.produk, required this.kuantitasMili});

  final ProdukData produk;
  final int kuantitasMili;

  /// Harga baris, dibulatkan ke rupiah terdekat karena uang tidak punya
  /// pecahan di aplikasi ini.
  int get subtotal => hitungSubtotalBaris(produk.hargaKatalog, kuantitasMili);

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

/// Keranjang yang sedang disusun.
///
/// Setiap perubahan langsung disimpan (user story 40) dan dipulihkan saat
/// aplikasi dibuka lagi (user story 41). Penyimpanannya lewat satu antrean
/// berurutan supaya ketukan cepat berturut-turut tidak saling mendahului dan
/// meninggalkan isi Keranjang yang bukan yang terakhir terlihat di layar.
class Keranjang extends Notifier<IsiKeranjang> {
  Future<void> _antrian = Future.value();
  bool _hidup = true;
  bool _dipulihkan = false;

  @override
  IsiKeranjang build() {
    _hidup = true;
    ref.onDispose(() => _hidup = false);
    _pulihkan();
    return const IsiKeranjang();
  }

  /// Memulihkan Keranjang yang tersimpan. Baris yang Produknya sudah tidak ada
  /// dilewati, dan Diskon yang menempel dibuang bila tidak ada baris tersisa.
  Future<void> _pulihkan() async {
    if (_dipulihkan) return;
    _dipulihkan = true;

    final store = ref.read(keranjangStoreProvider);
    final tersimpan = await store.baca();
    if (!_hidup || tersimpan == null) return;
    // Kasir sudah mengetuk sesuatu selagi pemulihan berjalan: isi di layar
    // lebih baru daripada yang tersimpan.
    if (!state.kosong) return;

    final db = ref.read(databaseProvider);
    final id = [for (final satu in tersimpan.baris) satu.produkId];
    final produk = await (db.select(
      db.produk,
    )..where((t) => t.id.isIn(id))).get();
    if (!_hidup) return;

    final perId = {for (final satu in produk) satu.id: satu};
    final baris = [
      for (final satu in tersimpan.baris)
        if (perId[satu.produkId] case final produk?)
          BarisKeranjang(produk: produk, kuantitasMili: satu.kuantitasMili),
    ];

    if (baris.isEmpty) {
      await store.hapus();
      return;
    }

    state = IsiKeranjang(baris: baris, diskon: tersimpan.diskon);
  }

  /// Menyimpan isi Keranjang sekarang. Keranjang kosong berarti tidak ada yang
  /// perlu dipulihkan, jadi barisnya dihapus (user story 42, 50).
  void _simpan() {
    final isi = state;
    final potret = isi.kosong
        ? null
        : IsiKeranjangTersimpan(
            baris: [
              for (final baris in isi.baris)
                BarisKeranjangTersimpan(
                  produkId: baris.produk.id,
                  kuantitasMili: baris.kuantitasMili,
                ),
            ],
            diskon: isi.diskon,
          );

    final store = ref.read(keranjangStoreProvider);
    _antrian = _antrian.then((_) async {
      if (potret == null) {
        await store.hapus();
      } else {
        await store.simpan(potret);
      }
    });
  }

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
      _simpan();
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
    _simpan();
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
    _simpan();
  }

  void hapus(int produkId) {
    final sisa = [
      for (final baris in state.baris)
        if (baris.produk.id != produkId) baris,
    ];
    // Keranjang kosong berarti transaksi baru: Diskon lama tidak boleh
    // menempel diam-diam pada belanja berikutnya.
    state = IsiKeranjang(baris: sisa, diskon: sisa.isEmpty ? null : state.diskon);
    _simpan();
  }

  /// `null` berarti Diskon dihapus dan Total kembali sama dengan Subtotal.
  void pasangDiskon(Diskon? diskon) {
    state = IsiKeranjang(baris: state.baris, diskon: diskon);
    _simpan();
  }

  /// Dipanggil setelah Transaksi tersimpan (user story 50) atau saat kasir
  /// sengaja mengosongkan Keranjang (user story 42).
  void kosongkan() {
    state = const IsiKeranjang();
    _simpan();
  }

  /// Menunggu semua penyimpanan yang masih mengantre selesai. Dipakai test
  /// supaya tidak perlu menebak kapan penulisan terakhir mendarat.
  Future<void> tungguTersimpan() => _antrian;
}

final keranjangProvider = NotifierProvider<Keranjang, IsiKeranjang>(
  Keranjang.new,
);
