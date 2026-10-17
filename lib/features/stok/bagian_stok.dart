import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/stok/stok_dialog.dart';
import 'package:kasir/features/stok/stok_providers.dart';

/// Bagian Stok di layar Produk: angka Stok sekarang, dua jalan mengubahnya,
/// dan riwayat pergerakannya. Angka di sini tidak pernah diketik langsung —
/// selalu hasil catatan (ADR-0003).
class BagianStok extends ConsumerWidget {
  const BagianStok({super.key, required this.produk});

  final ProdukData produk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(totalStokProvider).valueOrNull ?? const <int, int>{};
    final riwayat = ref.watch(pergerakanProvider(produk.id));
    final stok = total[produk.id] ?? 0;
    final teks = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        Text('Stok', style: teks.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Stok: ${formatKuantitas(stok)} ${produk.satuan}',
          key: const Key('stok-sekarang'),
          style: teks.headlineSmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.tonalIcon(
              key: const Key('stok-tambah'),
              onPressed: () => _tambah(context, ref, stok),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Stok'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const Key('stok-koreksi'),
              onPressed: () => _koreksi(context, ref, stok),
              child: const Text('Koreksi Stok'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Riwayat pergerakan', style: teks.titleSmall),
        const SizedBox(height: 4),
        riwayat.when(
          loading: () => const LinearProgressIndicator(),
          error: (galat, _) => Text('Gagal membaca riwayat: $galat'),
          data: (daftar) => Column(
            key: const Key('stok-riwayat'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (daftar.isEmpty)
                const Text('Belum ada pergerakan')
              else
                for (final catatan in daftar)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${_namaJenis(catatan.jenis)} · '
                      '${_tanda(catatan.jumlahMili)} ${produk.satuan} · '
                      '${formatWaktu(catatan.waktu)}',
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _tambah(BuildContext context, WidgetRef ref, int stok) async {
    final jumlah = await tanyaJumlahStok(
      context,
      produk: produk,
      stokSekarang: stok,
      koreksi: false,
    );
    if (jumlah == null || !context.mounted) return;

    await ref
        .read(stokStoreProvider)
        .tambahStok(
          produk.id,
          jumlahMili: jumlah,
          waktu: ref.read(clockProvider)(),
        );
  }

  Future<void> _koreksi(BuildContext context, WidgetRef ref, int stok) async {
    final stokBaru = await tanyaJumlahStok(
      context,
      produk: produk,
      stokSekarang: stok,
      koreksi: true,
    );
    if (stokBaru == null || !context.mounted) return;

    await ref
        .read(stokStoreProvider)
        .koreksiStok(
          produk.id,
          stokBaruMili: stokBaru,
          waktu: ref.read(clockProvider)(),
        );
  }

  static String _namaJenis(JenisPergerakan jenis) => switch (jenis) {
    JenisPergerakan.tambahStok => 'Tambah Stok',
    JenisPergerakan.koreksiStok => 'Koreksi Stok',
    JenisPergerakan.penjualan => 'Penjualan',
    JenisPergerakan.pembatalan => 'Pembatalan',
  };

  static String _tanda(int mili) =>
      mili >= 0 ? '+${formatKuantitas(mili)}' : formatKuantitas(mili);
}
