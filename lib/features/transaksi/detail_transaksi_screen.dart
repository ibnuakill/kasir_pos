import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:kasir/features/pin/pin_gate.dart';
import 'package:kasir/features/struk/bagikan_struk.dart';
import 'package:kasir/features/struk/isi_transaksi.dart';
import 'package:kasir/features/struk/struk_kertas.dart';

/// Detail satu Transaksi dari Laporan, lengkap dengan tombol bagikan dan
/// batalkan (user story 62, 63, 65).
///
/// Isinya adalah kertas Struk yang sama dengan pratinjau setelah pembayaran:
/// pemilik toko melihat persis apa yang dilihat pembeli, bukan ringkasan lain
/// yang bisa berbeda.
class DetailTransaksiScreen extends ConsumerStatefulWidget {
  const DetailTransaksiScreen({super.key, required this.transaksiId});

  final int transaksiId;

  static Future<void> buka(BuildContext context, int transaksiId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailTransaksiScreen(transaksiId: transaksiId),
      ),
    );
  }

  @override
  ConsumerState<DetailTransaksiScreen> createState() =>
      _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends ConsumerState<DetailTransaksiScreen> {
  final _kunciStruk = GlobalKey();
  late Future<IsiTransaksi> _isi = _muat();
  bool _sibuk = false;

  Future<IsiTransaksi> _muat() =>
      muatTransaksi(ref.read(databaseProvider), widget.transaksiId);

  Future<void> _bagikan(IsiTransaksi isi) async {
    setState(() => _sibuk = true);
    await bagikanStruk(
      ref: ref,
      context: context,
      kunci: _kunciStruk,
      transaksi: isi.transaksi,
    );
    if (mounted) setState(() => _sibuk = false);
  }

  Future<void> _batalkan() async {
    // PIN dulu, baru alasan: yang boleh membatalkan hanya pemilik toko, dan
    // alasan yang diketik setelah PIN benar tidak perlu diulang kalau PIN salah.
    final pinBenar = await mintaPin(context);
    if (!pinBenar || !mounted) return;

    final alasan = await showDialog<String>(
      context: context,
      builder: (_) => const _DialogAlasan(),
    );
    if (alasan == null || !mounted) return;

    setState(() => _sibuk = true);
    try {
      await TransaksiStore(ref.read(databaseProvider)).batalkan(
        widget.transaksiId,
        alasan: alasan,
        waktu: ref.read(clockProvider)(),
      );
      if (!mounted) return;
      setState(() {
        _isi = _muat();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi dibatalkan, Stok dikembalikan')),
      );
    } on TransaksiSudahBatalException {
      if (!mounted) return;
      setState(() {
        _isi = _muat();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaksi sudah dibatalkan')));
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: FutureBuilder<IsiTransaksi>(
        future: _isi,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Text(
                'Transaksi tidak bisa dimuat',
                key: const Key('detail-galat'),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final isi = snap.data!;
          return Column(
            children: [
              if (isi.transaksi.batal) _TandaBatal(transaksi: isi.transaksi),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Material(
                      elevation: 1,
                      child: RepaintBoundary(
                        key: _kunciStruk,
                        child: StrukKertas(
                          toko: isi.toko,
                          transaksi: isi.transaksi,
                          baris: isi.baris,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FutureBuilder<IsiTransaksi>(
            future: _isi,
            builder: (context, snap) {
              final isi = snap.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.tonalIcon(
                    key: const Key('detail-bagikan'),
                    onPressed: isi == null || _sibuk
                        ? null
                        : () => _bagikan(isi),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Bagikan Struk'),
                  ),
                  if (isi != null && !isi.transaksi.batal)
                    OutlinedButton.icon(
                      key: const Key('detail-batal'),
                      onPressed: _sibuk ? null : _batalkan,
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Batalkan Transaksi'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Penanda bahwa Transaksi sudah batal, beserta alasannya (user story 65).
class _TandaBatal extends StatelessWidget {
  const _TandaBatal({required this.transaksi});

  final TransaksiData transaksi;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Container(
      key: const Key('detail-batal-banner'),
      width: double.infinity,
      color: warna.errorContainer,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cancel, size: 18, color: warna.onErrorContainer),
              const SizedBox(width: 6),
              Text(
                'Transaksi Dibatalkan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: warna.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Alasan: ${transaksi.alasanBatal ?? '-'}',
            key: const Key('detail-alasan-batal'),
            style: TextStyle(color: warna.onErrorContainer),
          ),
          if (transaksi.waktuBatal != null)
            Text(
              'Dibatalkan ${formatWaktu(transaksi.waktuBatal!)}',
              style: TextStyle(color: warna.onErrorContainer),
            ),
        ],
      ),
    );
  }
}

/// Menanyakan alasan pembatalan. Tombol konfirmasi mati selama alasannya
/// kosong, karena alasan wajib diisi (user story 63).
class _DialogAlasan extends StatefulWidget {
  const _DialogAlasan();

  @override
  State<_DialogAlasan> createState() => _DialogAlasanState();
}

class _DialogAlasanState extends State<_DialogAlasan> {
  final _alasan = TextEditingController();

  @override
  void dispose() {
    _alasan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terisi = _alasan.text.trim().isNotEmpty;

    return AlertDialog(
      title: const Text('Batalkan Transaksi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stok akan dikembalikan dan Transaksi ditandai batal.'),
          const SizedBox(height: 12),
          TextField(
            key: const Key('detail-alasan'),
            controller: _alasan,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Alasan',
              hintText: 'Contoh: salah input',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('detail-alasan-batal'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tidak Jadi'),
        ),
        FilledButton(
          key: const Key('detail-batal-konfirmasi'),
          onPressed: terisi
              ? () => Navigator.of(context).pop(_alasan.text.trim())
              : null,
          child: const Text('Batalkan'),
        ),
      ],
    );
  }
}
