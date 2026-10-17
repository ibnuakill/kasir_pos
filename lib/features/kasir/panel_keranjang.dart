import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/features/kasir/diskon_dialog.dart';
import 'package:kasir/features/kasir/keranjang.dart';
import 'package:kasir/features/kasir/pembayaran_sheet.dart';
import 'package:kasir/features/stok/stok_rules.dart';

/// Isi Keranjang: baris yang bisa diubah Kuantitas-nya, bisa dihapus, dan
/// Subtotal yang mengikuti tanpa tombol hitung.
class PanelKeranjang extends ConsumerWidget {
  const PanelKeranjang({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isi = ref.watch(keranjangProvider);
    final teks = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text('Keranjang', style: teks.titleMedium),
              const Spacer(),
              Text('${isi.jumlahBaris} item'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: isi.kosong
              ? const Center(child: Text('Keranjang masih kosong'))
              : ListView.builder(
                  itemCount: isi.baris.length,
                  itemBuilder: (context, index) => _BarisKeranjangTile(
                    key: ValueKey(isi.baris[index].produk.id),
                    baris: isi.baris[index],
                  ),
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Text('Subtotal', style: teks.titleMedium),
              const Spacer(),
              Text(
                formatRupiah(isi.subtotal),
                key: const Key('keranjang-subtotal'),
                style: teks.titleMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: InkWell(
            key: const Key('kasir-atur-diskon'),
            onTap: () => _aturDiskon(context, ref, isi),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      isi.diskon == null ||
                              isi.diskon!.jenis == JenisDiskon.nominal
                          ? 'Diskon'
                          : 'Diskon (${formatDiskon(isi.diskon!)})',
                      style: teks.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatRupiah(isi.potongan),
                    key: const Key('keranjang-diskon'),
                    style: teks.bodyMedium,
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit_outlined, size: 16),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Total', style: teks.titleMedium),
                  const Spacer(),
                  Text(
                    formatRupiah(isi.total),
                    key: const Key('keranjang-total'),
                    style: teks.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('kasir-bayar'),
                  onPressed: isi.kosong
                      ? null
                      : () => PembayaranSheet.tampilkan(context),
                  child: const Text('Bayar'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _aturDiskon(
    BuildContext context,
    WidgetRef ref,
    IsiKeranjang isi,
  ) async {
    final hasil = await tanyaDiskon(
      context,
      subtotal: isi.subtotal,
      sekarang: isi.diskon,
    );
    if (hasil == null) return;

    ref
        .read(keranjangProvider.notifier)
        .pasangDiskon(hasil.hapus ? null : hasil.diskon);
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
