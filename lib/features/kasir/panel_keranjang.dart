import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/features/kasir/keranjang.dart';
import 'package:kasir/features/stok/stok_rules.dart';

/// Isi Keranjang: baris yang bisa diubah Kuantitas-nya, bisa dihapus, dan
/// Subtotal yang mengikuti tanpa tombol hitung.
class PanelKeranjang extends ConsumerWidget {
  const PanelKeranjang({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baris = ref.watch(keranjangProvider);
    final teks = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text('Keranjang', style: teks.titleMedium),
              const Spacer(),
              Text('${baris.length} item'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: baris.isEmpty
              ? const Center(child: Text('Keranjang masih kosong'))
              : ListView.builder(
                  itemCount: baris.length,
                  itemBuilder: (context, index) => _BarisKeranjangTile(
                    key: ValueKey(baris[index].produk.id),
                    baris: baris[index],
                  ),
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Subtotal', style: teks.titleMedium),
              const Spacer(),
              Text(
                formatRupiah(subtotalKeranjang(baris)),
                key: const Key('keranjang-subtotal'),
                style: teks.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarisKeranjangTile extends ConsumerStatefulWidget {
  const _BarisKeranjangTile({super.key, required this.baris});

  final BarisKeranjang baris;

  @override
  ConsumerState<_BarisKeranjangTile> createState() =>
      _BarisKeranjangTileState();
}

class _BarisKeranjangTileState extends ConsumerState<_BarisKeranjangTile> {
  late final TextEditingController _kuantitas = TextEditingController(
    text: formatKuantitas(widget.baris.kuantitasMili),
  );
  String? _galat;

  @override
  void didUpdateWidget(covariant _BarisKeranjangTile lama) {
    super.didUpdateWidget(lama);
    final teks = formatKuantitas(widget.baris.kuantitasMili);
    if (_kuantitas.text != teks) _kuantitas.text = teks;
  }

  @override
  void dispose() {
    _kuantitas.dispose();
    super.dispose();
  }

  void _ubah(String teks) {
    final galat = validasiJumlahStok(
      teks,
      bolehPecahan: widget.baris.produk.bolehPecahan,
      bolehNol: false,
    );
    setState(() => _galat = galat);
    if (galat != null) return;

    ref
        .read(keranjangProvider.notifier)
        .ubahKuantitas(widget.baris.produk.id, parseKuantitas(teks)!);
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.baris.produk;
    final teks = Theme.of(context).textTheme;

    return Padding(
      key: Key('keranjang-baris-${produk.id}'),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produk.nama),
                    Text(
                      '${formatRupiah(produk.hargaKatalog)} per ${produk.satuan}',
                      style: teks.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 84,
                child: TextField(
                  key: Key('keranjang-qty-${produk.id}'),
                  controller: _kuantitas,
                  textAlign: TextAlign.end,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixText: produk.satuan,
                  ),
                  onChanged: _ubah,
                ),
              ),
              IconButton(
                key: Key('keranjang-hapus-${produk.id}'),
                tooltip: 'Hapus baris',
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    ref.read(keranjangProvider.notifier).hapus(produk.id),
              ),
            ],
          ),
          if (_galat != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _galat!,
                style: teks.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
