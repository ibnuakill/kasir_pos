import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:kasir/features/kasir/keranjang.dart';

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
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _menyimpan = true;
      _galatSimpan = null;
    });

    try {
      final hasil = await TransaksiStore(ref.read(databaseProvider)).simpan(
        waktu: ref.read(clockProvider)(),
        metodeBayar: MetodeBayar.tunai,
        baris: [
          for (final baris in isi.baris)
            BarisTerjual(
              produk: baris.produk,
              kuantitasMili: baris.kuantitasMili,
            ),
        ],
        diskon: isi.diskon,
        uangDiterima: _diterima,
      );

      if (!mounted) return;
      ref.read(keranjangProvider.notifier).kosongkan();
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Transaksi ${hasil.nomor} tersimpan')),
      );
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
    final kurang = _diterima != null && _diterima! < isi.total;
    final kembalian = _diterima == null || kurang ? 0 : _diterima! - isi.total;
    final galat = _galatSimpan ?? (kurang ? 'Uang diterima kurang dari Total' : null);

    return Padding(
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
          Text('Pembayaran Tunai', style: teks.titleMedium),
          const SizedBox(height: 12),
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
            onPressed: _menyimpan || kurang || _diterima == null
                ? null
                : _simpan,
            child: const Text('Simpan Transaksi'),
          ),
        ],
      ),
    );
  }
}
