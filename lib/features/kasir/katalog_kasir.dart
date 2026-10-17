import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/kasir/keranjang.dart';
import 'package:kasir/features/produk/foto_produk.dart';
import 'package:kasir/features/produk/produk_providers.dart';
import 'package:kasir/features/stok/stok_providers.dart';

/// Katalog di layar kasir: hanya Produk aktif, bisa disaring per Kategori dan
/// dicari. Satu ketukan memasukkan Produk ke Keranjang.
class KatalogKasir extends ConsumerStatefulWidget {
  const KatalogKasir({super.key});

  @override
  ConsumerState<KatalogKasir> createState() => _KatalogKasirState();
}

class _KatalogKasirState extends ConsumerState<KatalogKasir> {
  final _cari = TextEditingController();
  int? _kategoriId;

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  void _pilih(ProdukData produk, int stok) {
    if (stok <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Stok ${produk.nama} masih nol. Isi Stok dulu di tab Produk.',
            ),
          ),
        );
      return;
    }

    ref.read(keranjangProvider.notifier).tambah(produk);
  }

  @override
  Widget build(BuildContext context) {
    final semua = ref.watch(daftarProdukProvider).valueOrNull ?? const [];
    final kategori = ref.watch(daftarKategoriProvider).valueOrNull ?? const [];
    final stok = ref.watch(totalStokProvider).valueOrNull ?? const <int, int>{};

    final kata = _cari.text.trim().toLowerCase();
    final daftar = [
      for (final produk in semua)
        if (produk.aktif &&
            (_kategoriId == null || produk.kategoriId == _kategoriId) &&
            (kata.isEmpty || produk.nama.toLowerCase().contains(kata)))
          produk,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            key: const Key('kasir-cari'),
            controller: _cari,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Cari produk',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _chip(
                kunci: 'kasir-kategori-semua',
                label: 'Semua',
                id: null,
              ),
              for (final item in kategori)
                _chip(
                  kunci: 'kasir-kategori-${item.id}',
                  label: item.nama,
                  id: item.id,
                ),
            ],
          ),
        ),
        Expanded(
          child: daftar.isEmpty
              ? const Center(child: Text('Tidak ada produk yang cocok'))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.1,
                      ),
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final produk = daftar[index];
                    return _KartuProduk(
                      produk: produk,
                      stok: stok[produk.id] ?? 0,
                      onTap: () => _pilih(produk, stok[produk.id] ?? 0),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _chip({required String kunci, required String label, int? id}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        key: Key(kunci),
        label: Text(label),
        selected: _kategoriId == id,
        onSelected: (_) => setState(() => _kategoriId = id),
      ),
    );
  }
}

class _KartuProduk extends StatelessWidget {
  const _KartuProduk({
    required this.produk,
    required this.stok,
    required this.onTap,
  });

  final ProdukData produk;
  final int stok;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    final habis = stok <= 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('kasir-produk-${produk.id}'),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FotoProduk(
                key: Key('kasir-foto-${produk.id}'),
                path: produk.foto,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: teks.titleSmall,
                  ),
                  Text(
                    formatRupiah(produk.hargaKatalog),
                    style: teks.bodyMedium,
                  ),
                  Text(
                    habis ? 'stok habis' : 'stok ${formatKuantitas(stok)}',
                    style: teks.bodySmall?.copyWith(
                      color: habis
                          ? Theme.of(context).colorScheme.error
                          : teks.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
