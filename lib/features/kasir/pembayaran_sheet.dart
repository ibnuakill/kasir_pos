import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:kasir/features/kasir/keranjang.dart';
import 'package:kasir/features/struk/struk_screen.dart';

/// Lembar pembayaran Tunai: kasir memasukkan uang yang diterima, Kembalian
/// dihitung sambil mengetik, dan satu tombol menyimpan Transaksi
/// (user story 44, 45, 47).
class PembayaranSheet extends ConsumerStatefulWidget {
  const PembayaranSheet({super.key});

  static Future<void> tampilkan(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PembayaranSheet(),
    );
  }

  @override
  ConsumerState<PembayaranSheet> createState() => _PembayaranSheetState();
}

class _PembayaranSheetState extends ConsumerState<PembayaranSheet> {
  final _uang = TextEditingController();
  MetodeBayar _metode = MetodeBayar.tunai;
  int? _diterima;
  String? _galatSimpan;
  bool _menyimpan = false;

  @override
  void dispose() {
    _uang.dispose();
    super.dispose();
  }

  void _ubah(String teks) {
    setState(() {
      _diterima = parseRupiah(teks);
      _galatSimpan = null;
    });
  }

  Future<void> _simpan() async {
    final isi = ref.read(keranjangProvider);
    final metode = _metode;
    final navigator = Navigator.of(context);

    setState(() {
      _menyimpan = true;
      _galatSimpan = null;
    });

    try {
      final hasil = await TransaksiStore(ref.read(databaseProvider)).simpan(
        waktu: ref.read(clockProvider)(),
        metodeBayar: metode,
        baris: [
          for (final baris in isi.baris)
            BarisTerjual(
              produk: baris.produk,
              kuantitasMili: baris.kuantitasMili,
            ),
        ],
        diskon: isi.diskon,
        // QRIS tidak punya uang diterima dan Kembalian (user story 43).
        uangDiterima: metode == MetodeBayar.tunai ? _diterima : null,
      );

      if (!mounted) return;
      ref.read(keranjangProvider.notifier).kosongkan();
      navigator.pop();

      // Struk langsung tampil begitu Transaksi tersimpan (user story 51) —
      // itulah bukti Transaksi berhasil, bukan sekadar pesan singkat.
      await StrukScreen.buka(navigator.context, hasil.id);
    } on UangKurangException {
      setState(() {
        _menyimpan = false;
        _galatSimpan = 'Uang diterima kurang dari Total';
      });
    } on StokKurangException catch (galat) {
      setState(() {
        _menyimpan = false;
        _galatSimpan = '$galat';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isi = ref.watch(keranjangProvider);
    final teks = Theme.of(context).textTheme;
    final tunai = _metode == MetodeBayar.tunai;
    final kurang = tunai && _diterima != null && _diterima! < isi.total;
    final kembalian = !tunai || _diterima == null || kurang
        ? 0
        : _diterima! - isi.total;
    final galat =
        _galatSimpan ?? (kurang ? 'Uang diterima kurang dari Total' : null);
    final bisaSimpan = tunai ? _diterima != null && !kurang : true;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pembayaran', style: teks.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<MetodeBayar>(
            key: const Key('bayar-metode'),
            segments: const [
              ButtonSegment(
                value: MetodeBayar.tunai,
                label: Text('Tunai'),
                icon: Icon(Icons.payments_outlined),
              ),
              ButtonSegment(
                value: MetodeBayar.qris,
                label: Text('QRIS'),
                icon: Icon(Icons.qr_code_2),
              ),
            ],
            selected: {_metode},
            onSelectionChanged: (pilihan) => setState(() {
              _metode = pilihan.first;
              _galatSimpan = null;
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Total', style: teks.bodyMedium),
              const Spacer(),
              Text(
                formatRupiah(isi.total),
                key: const Key('bayar-total'),
                style: teks.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tunai) ...[
            TextField(
              key: const Key('bayar-uang-diterima'),
              controller: _uang,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Uang diterima',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: _ubah,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Kembalian', style: teks.bodyMedium),
                const Spacer(),
                Text(
                  formatRupiah(kembalian),
                  key: const Key('bayar-kembalian'),
                  style: teks.titleMedium,
                ),
              ],
            ),
          ] else
            _bagianQris(context),
          if (galat != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                galat,
                key: const Key('bayar-error'),
                style: teks.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('bayar-simpan'),
            onPressed: _menyimpan || !bisaSimpan ? null : _simpan,
            child: const Text('Simpan Transaksi'),
          ),
        ],
      ),
    );
  }

  /// QRIS: pembeli memindai gambar QR milik toko. Tidak ada uang diterima dan
  /// tidak ada Kembalian (user story 43, 46).
  Widget _bagianQris(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    final gambar = ref.watch(gambarQrisProvider);

    return gambar.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Text('Gagal memuat gambar QR: $error'),
      data: (path) {
        if (path == null) {
          return Container(
            key: const Key('bayar-qris-kosong'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Gambar QR belum diatur di Pengaturan, jadi pembeli belum bisa '
              'memindai. Transaksi tetap bisa disimpan.',
              style: teks.bodyMedium,
            ),
          );
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.file(
                File(path),
                key: const Key('bayar-gambar-qris'),
                height: 240,
                fit: BoxFit.contain,
                errorBuilder: (context, _, _) =>
                    const Text('Gambar QR tidak bisa dibaca'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Minta pembeli memindai QR ini.',
              style: teks.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
