import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:kasir/features/struk/gambar_struk.dart';
import 'package:kasir/features/struk/struk_kertas.dart';

/// Pratinjau Struk satu Transaksi, lengkap dengan tombol bagikan
/// (user story 51, 57).
///
/// Layar ini membaca Transaksi dari database berdasarkan id, bukan menerima
/// objek jadi — supaya detail Transaksi (tiket 13) bisa memakai layar yang
/// sama untuk membagikan ulang Struk lama (user story 58).
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
  late final Future<_IsiStruk> _isi = _muat();
  bool _membagikan = false;

  Future<_IsiStruk> _muat() async {
    final database = ref.read(databaseProvider);
    final transaksi = await (database.select(
      database.transaksi,
    )..where((t) => t.id.equals(widget.transaksiId))).getSingleOrNull();

    if (transaksi == null) {
      throw StateError('Transaksi tidak ditemukan');
    }

    return _IsiStruk(
      toko: await TokoStore(database).baca(),
      transaksi: transaksi,
      baris: await TransaksiStore(database).barisDari(transaksi.id),
    );
  }

  Future<void> _bagikan(TransaksiData transaksi) async {
    setState(() => _membagikan = true);
    try {
      final png = await gambarStrukPng(_kunciStruk);
      await ref
          .read(pembagiProvider)
          .bagikanGambar(
            png,
            namaBerkas: 'struk-${transaksi.nomor}.png',
            teks: 'Struk ${transaksi.nomor}',
          );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Struk gagal dibagikan')));
    } finally {
      if (mounted) setState(() => _membagikan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Struk')),
      body: FutureBuilder<_IsiStruk>(
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
          child: FutureBuilder<_IsiStruk>(
            future: _isi,
            builder: (context, snap) {
              final transaksi = snap.data?.transaksi;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    key: const Key('struk-bagikan'),
                    onPressed: transaksi == null || _membagikan
                        ? null
                        : () => _bagikan(transaksi),
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

class _IsiStruk {
  const _IsiStruk({
    required this.toko,
    required this.transaksi,
    required this.baris,
  });

  final Toko? toko;
  final TransaksiData transaksi;
  final List<BarisTransaksiData> baris;
}
