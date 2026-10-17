import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/features/struk/bagikan_struk.dart';
import 'package:kasir/features/struk/isi_transaksi.dart';
import 'package:kasir/features/struk/struk_kertas.dart';

/// Pratinjau Struk satu Transaksi tepat setelah pembayaran, lengkap dengan
/// tombol bagikan (user story 51, 57).
///
/// Layar ini membaca Transaksi dari database berdasarkan id, bukan menerima
/// objek jadi — supaya detail Transaksi memakai pembacaan yang sama.
class StrukScreen extends ConsumerStatefulWidget {
  const StrukScreen({super.key, required this.transaksiId});

  final int transaksiId;

  static Future<void> buka(BuildContext context, int transaksiId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StrukScreen(transaksiId: transaksiId),
      ),
    );
  }

  @override
  ConsumerState<StrukScreen> createState() => _StrukScreenState();
}

class _StrukScreenState extends ConsumerState<StrukScreen> {
  final _kunciStruk = GlobalKey();
  late final Future<IsiTransaksi> _isi = muatTransaksi(
    ref.read(databaseProvider),
    widget.transaksiId,
  );
  bool _membagikan = false;

  Future<void> _bagikan(IsiTransaksi isi) async {
    setState(() => _membagikan = true);
    await bagikanStruk(
      ref: ref,
      context: context,
      kunci: _kunciStruk,
      transaksi: isi.transaksi,
    );
    if (mounted) setState(() => _membagikan = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Struk')),
      body: FutureBuilder<IsiTransaksi>(
        future: _isi,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Text(
                'Struk tidak bisa dimuat',
                key: const Key('struk-galat'),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final isi = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                  FilledButton.icon(
                    key: const Key('struk-bagikan'),
                    onPressed: isi == null || _membagikan
                        ? null
                        : () => _bagikan(isi),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Bagikan Struk'),
                  ),
                  TextButton(
                    key: const Key('struk-selesai'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Selesai'),
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
