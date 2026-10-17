import 'package:drift/drift.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/nomor_transaksi.dart';
import 'package:kasir/core/rupiah.dart';

import 'database.dart';

/// Satu baris Keranjang yang siap disimpan sebagai bagian Transaksi. Harga
/// yang dipakai adalah Harga Katalog saat baris masuk Keranjang, bukan harga
/// katalog terbaru (user story 36).
class BarisTerjual {
  const BarisTerjual({required this.produk, required this.kuantitasMili});

  final ProdukData produk;
  final int kuantitasMili;

  int get hargaSatuan => produk.hargaKatalog;

  /// Sama persis dengan pembulatan di Keranjang, supaya angka di layar dan
  /// angka yang tersimpan tidak pernah beda satu rupiah.
  int get subtotal => hitungSubtotalBaris(hargaSatuan, kuantitasMili);
}

/// Uang tunai yang diserahkan pembeli belum menutup Total (user story 45).
class UangKurangException implements Exception {
  const UangKurangException({required this.total, required this.uangDiterima});

  final int total;
  final int uangDiterima;

  @override
  String toString() => 'Uang diterima kurang dari Total';
}

/// Stok tidak cukup untuk Kuantitas yang diminta, jadi Transaksi ditolak
/// (user story 34). Diperiksa saat menyimpan, karena Keranjang sendiri tidak
/// mengunci Kuantitas pada Stok.
class StokKurangException implements Exception {
  const StokKurangException({
    required this.namaProduk,
    required this.satuan,
    required this.sisaMili,
    required this.dimintaMili,
  });

  final String namaProduk;
  final String satuan;
  final int sisaMili;
  final int dimintaMili;

  @override
  String toString() =>
      'Stok $namaProduk tinggal ${formatKuantitas(sisaMili)} $satuan';
}

/// Menyimpan Transaksi: memberi nomor, membekukan harga, dan menulis
/// pergerakan Stok keluar — semuanya dalam satu transaksi database supaya
/// tidak pernah ada Transaksi tersimpan tanpa Stok yang berkurang.
class TransaksiStore {
  const TransaksiStore(this._db);

  final AppDatabase _db;

  Future<TransaksiData> simpan({
    required DateTime waktu,
    required MetodeBayar metodeBayar,
    required List<BarisTerjual> baris,
    Diskon? diskon,
    int? uangDiterima,
  }) async {
    if (baris.isEmpty) {
      throw ArgumentError.value(
        baris,
        'baris',
        'Transaksi harus punya minimal satu baris',
      );
    }

    final subtotal = baris.fold(0, (jumlah, satu) => jumlah + satu.subtotal);
    final potongan = hitungPotongan(subtotal, diskon);
    final total = subtotal - potongan;
    final tunai = metodeBayar == MetodeBayar.tunai;
    final uang = uangDiterima ?? total;

    if (tunai && uang < total) {
      throw UangKurangException(total: total, uangDiterima: uang);
    }

    return _db.transaction(() async {
      final diminta = <int, int>{};
      final nama = <int, ProdukData>{};

      for (final satu in baris) {
        diminta.update(
          satu.produk.id,
          (lama) => lama + satu.kuantitasMili,
          ifAbsent: () => satu.kuantitasMili,
        );
        nama[satu.produk.id] = satu.produk;
      }

      // Diperiksa per Produk, bukan per baris: dua baris Produk yang sama
      // harus dijumlahkan dulu sebelum dibandingkan dengan Stok.
      for (final permintaan in diminta.entries) {
        final sisa = await _stokSekarang(permintaan.key);
        if (sisa < permintaan.value) {
          final produk = nama[permintaan.key]!;
          throw StokKurangException(
            namaProduk: produk.nama,
            satuan: produk.satuan,
            sisaMili: sisa,
            dimintaMili: permintaan.value,
          );
        }
      }

      final nomor = await _nomorBerikut(waktu);
      final id = await _db
          .into(_db.transaksi)
          .insert(
            TransaksiCompanion.insert(
              nomor: nomor,
              waktu: waktu,
              metodeBayar: metodeBayar,
              subtotal: subtotal,
              diskonJenis: Value(diskon?.jenis),
              diskonNilai: Value(diskon?.nilai),
              potongan: potongan,
              total: total,
              uangDiterima: Value(tunai ? uang : null),
              kembalian: Value(tunai ? uang - total : null),
            ),
          );

      for (final satu in baris) {
        await _db
            .into(_db.barisTransaksi)
            .insert(
              BarisTransaksiCompanion.insert(
                transaksiId: id,
                produkId: satu.produk.id,
                namaProduk: satu.produk.nama,
                satuan: satu.produk.satuan,
                hargaSatuan: satu.hargaSatuan,
                kuantitasMili: satu.kuantitasMili,
                subtotal: satu.subtotal,
              ),
            );
        await _db
            .into(_db.pergerakanStok)
            .insert(
              PergerakanStokCompanion.insert(
                produkId: satu.produk.id,
                jenis: JenisPergerakan.penjualan,
                jumlahMili: -satu.kuantitasMili,
                waktu: waktu,
              ),
            );
      }

      return (_db.select(
        _db.transaksi,
      )..where((t) => t.id.equals(id))).getSingle();
    });
  }

  /// Baris milik satu Transaksi, urut sebagaimana dimasukkan ke Keranjang.
  Future<List<BarisTransaksiData>> barisDari(int transaksiId) {
    final query = _db.select(_db.barisTransaksi)
      ..where((t) => t.transaksiId.equals(transaksiId))
      ..orderBy([(t) => OrderingTerm(expression: t.id)]);
    return query.get();
  }

  /// Nomor berikutnya untuk hari yang sama. Dihitung di dalam transaksi
  /// database, jadi dua penyimpanan berurutan tidak mungkin mendapat nomor
  /// kembar; kolom `nomor` yang unik menjadi jaring pengaman terakhir.
  Future<String> _nomorBerikut(DateTime waktu) async {
    final prefix = prefixNomorTransaksi(waktu);
    final query = _db.selectOnly(_db.transaksi)
      ..addColumns([_db.transaksi.nomor])
      ..where(_db.transaksi.nomor.like('$prefix%'));

    var tertinggi = 0;
    for (final baris in await query.get()) {
      final urutan = urutanNomorTransaksi(baris.read(_db.transaksi.nomor)!) ?? 0;
      if (urutan > tertinggi) tertinggi = urutan;
    }
    return formatNomorTransaksi(waktu, tertinggi + 1);
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
