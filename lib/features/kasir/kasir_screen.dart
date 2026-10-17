import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/features/kasir/keranjang.dart';
import 'package:kasir/features/kasir/katalog_kasir.dart';
import 'package:kasir/features/kasir/panel_keranjang.dart';

/// Layar kasir. Di layar lebar katalog dan Keranjang berdampingan; di layar
/// sempit Keranjang jadi panel bawah, dengan jumlah item dan Total tetap
/// terlihat supaya konteks tidak hilang (user story 79–81).
class KasirScreen extends StatelessWidget {
  const KasirScreen({super.key});

  /// Satu breakpoint untuk seluruh aplikasi: di bawah ini dianggap HP.
  static const double lebarTablet = 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir')),
      body: LayoutBuilder(
        builder: (context, batas) {
          if (batas.maxWidth >= lebarTablet) {
            return const Row(
              children: [
                Expanded(child: KatalogKasir()),
                VerticalDivider(width: 1),
                SizedBox(width: 340, child: PanelKeranjang()),
              ],
            );
          }

          return const Column(
            children: [
              Expanded(child: KatalogKasir()),
              _BarTotal(),
            ],
          );
        },
      ),
    );
  }
}

/// Bar bawah di layar sempit: jumlah item dan Total selalu kelihatan, dan
/// ketukan membuka panel Keranjang.
class _BarTotal extends ConsumerWidget {
  const _BarTotal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isi = ref.watch(keranjangProvider);
    final teks = Theme.of(context).textTheme;

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        key: const Key('kasir-buka-keranjang'),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const PanelKeranjang(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Icon(Icons.shopping_cart_outlined, size: 20, color: teks.bodySmall?.color),
              const SizedBox(width: 8),
              Text('${isi.jumlahBaris} item', style: teks.bodyMedium),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Total ${formatRupiah(isi.total)}',
                  key: const Key('kasir-total-bar'),
                  textAlign: TextAlign.end,
                  style: teks.titleMedium,
                ),
              ),
              const Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
      ),
    );
  }
}
