import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/produk/foto_produk.dart';
import 'package:kasir/features/produk/produk_form_screen.dart';
import 'package:kasir/features/produk/produk_providers.dart';
import 'package:kasir/features/stok/stok_providers.dart';

/// Daftar katalog. Produk nonaktif disembunyikan sampai diminta, karena yang
/// dicari kasir sehari-hari adalah barang yang masih dijual.
class ProdukScreen extends ConsumerStatefulWidget {
  const ProdukScreen({super.key});

  @override
  ConsumerState<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends ConsumerState<ProdukScreen> {
  final _cari = TextEditingController();
  bool _sertakanNonaktif = false;

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  Future<void> _bukaForm({ProdukData? produk}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ProdukFormScreen(produk: produk)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produk = ref.watch(daftarProdukProvider);
    final kategori = ref.watch(daftarKategoriProvider).valueOrNull ?? const [];
    final namaKategori = {for (final k in kategori) k.id: k.nama};
    final stok = ref.watch(totalStokProvider).valueOrNull ?? const <int, int>{};

    // Penyaringan di sini, bukan di query: satu langganan untuk seluruh katalog.
    final kata = _cari.text.trim().toLowerCase();
    List<ProdukData> saring(List<ProdukData> semua) => [
      for (final item in semua)
        if ((_sertakanNonaktif || item.aktif) &&
            (kata.isEmpty || item.nama.toLowerCase().contains(kata)))
          item,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Produk')),
      floatingActionButton: FloatingActionButton(
        key: const Key('produk-tambah'),
        onPressed: () => _bukaForm(),
        tooltip: 'Tambah produk',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              key: const Key('produk-cari'),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FilterChip(
                key: const Key('produk-tampilkan-nonaktif'),
                label: const Text('Tampilkan nonaktif'),
                selected: _sertakanNonaktif,
                onSelected: (value) =>
                    setState(() => _sertakanNonaktif = value),
              ),
            ),
          ),
          Expanded(
            child: produk.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Gagal memuat: $error')),
              data: (semua) {
                final daftar = saring(semua);
                if (daftar.isEmpty) {
                  return const Center(
                    child: Text('Belum ada produk yang cocok'),
                  );
                }
                return ListView.builder(
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final item = daftar[index];
                    return ListTile(
                      key: Key('produk-baris-${item.id}'),
                      leading: FotoProduk(
                        key: Key('produk-foto-${item.id}'),
                        path: item.foto,
                        ukuran: 48,
                      ),
                      title: Text(item.nama),
                      subtitle: Text(
                        [
                          formatRupiah(item.hargaKatalog),
                          'per ${item.satuan}',
                          'stok ${formatKuantitas(stok[item.id] ?? 0)}',
                          if (namaKategori[item.kategoriId] != null)
                            namaKategori[item.kategoriId]!,
                        ].join(' · '),
                      ),
                      trailing: item.aktif
                          ? null
                          : const Text(
                              'Nonaktif',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                      onTap: () => _bukaForm(produk: item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
