import 'package:flutter/material.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/toko_store.dart';

/// Isi Struk yang dilihat pembeli (user story 52–56).
///
/// Warnanya sengaja dikunci terang: Struk berpindah jadi gambar, jadi tidak
/// boleh ikut jadi gelap saat HP memakai mode gelap.
class StrukKertas extends StatelessWidget {
  const StrukKertas({
    super.key,
    required this.toko,
    required this.transaksi,
    required this.baris,
  });

  final Toko? toko;
  final TransaksiData transaksi;
  final List<BarisTransaksiData> baris;

  static const _tinta = Color(0xFF1A1A1A);
  static const _redup = Color(0xFF5F5F5F);

  @override
  Widget build(BuildContext context) {
    final tunai = transaksi.metodeBayar == MetodeBayar.tunai;
    final diskon = transaksi.diskonJenis == null || transaksi.diskonNilai == null
        ? null
        : Diskon(jenis: transaksi.diskonJenis!, nilai: transaksi.diskonNilai!);

    return Container(
      key: const Key('struk-kertas'),
      width: 320,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            toko?.nama ?? 'Toko',
            key: const Key('struk-toko'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _tinta,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if ((toko?.alamat ?? '').isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              toko!.alamat,
              key: const Key('struk-alamat'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: _redup, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          const _Garis(),
          const SizedBox(height: 8),
          Text(
            transaksi.nomor,
            key: const Key('struk-nomor'),
            style: const TextStyle(
              color: _tinta,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formatWaktu(transaksi.waktu),
            key: const Key('struk-waktu'),
            style: const TextStyle(color: _redup, fontSize: 12),
          ),
          const SizedBox(height: 8),
          const _Garis(),
          const SizedBox(height: 8),
          for (var i = 0; i < baris.length; i++)
            Padding(
              key: Key('struk-item-$i'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    baris[i].namaProduk,
                    style: const TextStyle(color: _tinta, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${formatKuantitas(baris[i].kuantitasMili)} '
                          '${baris[i].satuan} × '
                          '${formatRupiah(baris[i].hargaSatuan)}',
                          style: const TextStyle(color: _redup, fontSize: 12),
                        ),
                      ),
                      Text(
                        formatRupiah(baris[i].subtotal),
                        style: const TextStyle(color: _tinta, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const _Garis(),
          const SizedBox(height: 8),
          _BarisStruk(
            kunci: const Key('struk-subtotal'),
            label: 'Subtotal',
            nilai: formatRupiah(transaksi.subtotal),
          ),
          if (diskon != null)
            _BarisStruk(
              kunci: const Key('struk-diskon'),
              label: 'Diskon ${formatDiskon(diskon)}',
              nilai: '-${formatRupiah(transaksi.potongan)}',
            ),
          const SizedBox(height: 4),
          _BarisStruk(
            kunci: const Key('struk-total'),
            label: 'Total',
            nilai: formatRupiah(transaksi.total),
            tebal: true,
          ),
          const SizedBox(height: 8),
          _BarisStruk(
            kunci: const Key('struk-metode'),
            label: 'Metode Bayar',
            nilai: tunai ? 'Tunai' : 'QRIS',
          ),
          // QRIS tidak punya uang diterima maupun Kembalian, jadi barisnya
          // tidak ditampilkan sama sekali (user story 43, 56).
          if (tunai) ...[
            _BarisStruk(
              kunci: const Key('struk-uang-diterima'),
              label: 'Uang Diterima',
              nilai: formatRupiah(transaksi.uangDiterima ?? transaksi.total),
            ),
            _BarisStruk(
              kunci: const Key('struk-kembalian'),
              label: 'Kembalian',
              nilai: formatRupiah(
                transaksi.kembalian ?? 0,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const _Garis(),
          const SizedBox(height: 12),
          const Text(
            'Terima kasih',
            textAlign: TextAlign.center,
            style: TextStyle(color: _redup, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _BarisStruk extends StatelessWidget {
  const _BarisStruk({
    required this.label,
    required this.nilai,
    this.tebal = false,
    this.kunci,
  });

  final String label;
  final String nilai;
  final bool tebal;
  final Key? kunci;

  @override
  Widget build(BuildContext context) {
    final gaya = TextStyle(
      color: StrukKertas._tinta,
      fontSize: tebal ? 14 : 13,
      fontWeight: tebal ? FontWeight.w700 : FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: gaya)),
          // Kunci ditaruh di angka, bukan di barisnya, supaya test bisa membaca
          // nilainya langsung.
          Text(nilai, key: kunci, style: gaya),
        ],
      ),
    );
  }
}

/// Garis pemisah bergaya struk kertas, bukan `Divider` bawaan tema.
class _Garis extends StatelessWidget {
  const _Garis();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: const Color(0xFFBFBFBF));
}
