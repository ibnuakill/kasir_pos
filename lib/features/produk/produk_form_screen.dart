import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/produk/foto_produk.dart';
import 'package:kasir/features/produk/produk_providers.dart';
import 'package:kasir/features/stok/bagian_stok.dart';

/// Formulir tambah dan ubah Produk. Tidak ada tombol hapus: Produk hanya bisa
/// dinonaktifkan (ADR-0004).
class ProdukFormScreen extends ConsumerStatefulWidget {
  const ProdukFormScreen({super.key, this.produk});

  final ProdukData? produk;

  @override
  ConsumerState<ProdukFormScreen> createState() => _ProdukFormScreenState();
}

class _ProdukFormScreenState extends ConsumerState<ProdukFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.produk?.nama ?? '');
  late final _harga = TextEditingController(
    text: widget.produk?.hargaKatalog.toString() ?? '',
  );
  late final _satuan = TextEditingController(text: widget.produk?.satuan ?? '');

  late bool _bolehPecahan = widget.produk?.bolehPecahan ?? false;
  late int? _kategoriId = widget.produk?.kategoriId;

  /// Berkas yang baru dipilih tapi belum disalin: nama berkasnya menunggu id
  /// Produk, yang baru ada setelah barisnya disimpan.
  String? _sumberFoto;

  bool _fotoDihapus = false;

  /// Yang ditampilkan di formulir: pilihan baru, atau foto lama, atau kosong.
  String? get _fotoTampil =>
      _sumberFoto ?? (_fotoDihapus ? null : widget.produk?.foto);

  bool get _mengubah => widget.produk != null;

  @override
  void dispose() {
    _nama.dispose();
    _harga.dispose();
    _satuan.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final store = ref.read(produkStoreProvider);
    final gambar = ref.read(gambarStoreProvider);
    final harga = parseRupiah(_harga.text) ?? 0;

    final int id;
    if (_mengubah) {
      id = widget.produk!.id;
      await store.ubah(
        id,
        nama: _nama.text,
        hargaKatalog: harga,
        satuan: _satuan.text,
        bolehPecahan: _bolehPecahan,
        kategoriId: _kategoriId,
      );
    } else {
      id = await store.tambah(
        nama: _nama.text,
        hargaKatalog: harga,
        satuan: _satuan.text,
        bolehPecahan: _bolehPecahan,
        kategoriId: _kategoriId,
      );
    }

    // Foto disalin setelah Produk punya id, dan dinamai menurut id itu:
    // mengganti foto otomatis membuang berkas lama, bukan menumpuk berkas baru.
    if (_sumberFoto != null) {
      final path = await gambar.simpanDari(_sumberFoto!, nama: 'produk-$id');
      await store.setFoto(id, path);
    } else if (_fotoDihapus) {
      await gambar.hapus(widget.produk?.foto);
      await store.setFoto(id, null);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pilihFoto({required bool kamera}) async {
    final pemilih = ref.read(pemilihGambarProvider);
    final sumber = kamera
        ? await pemilih.dariKamera()
        : await pemilih.dariGaleri();
    if (sumber == null || !mounted) return;

    setState(() {
      _sumberFoto = sumber;
      _fotoDihapus = false;
    });
  }

  Future<void> _ubahStatus() async {
    await ref
        .read(produkStoreProvider)
        .setAktif(widget.produk!.id, !widget.produk!.aktif);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _buatKategori() async {
    final nama = await showDialog<String>(
      context: context,
      builder: (_) => const _KategoriBaruDialog(),
    );
    if (nama == null || !mounted) return;

    final id = await ref.read(kategoriStoreProvider).tambah(nama);
    if (!mounted) return;
    setState(() => _kategoriId = id);
  }

  @override
  Widget build(BuildContext context) {
    final kategori = ref.watch(daftarKategoriProvider).valueOrNull ?? const [];
    final hargaTerbaca = parseRupiah(_harga.text);

    return Scaffold(
      appBar: AppBar(title: Text(_mengubah ? 'Ubah produk' : 'Produk baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FotoProduk(
                  key: const Key('produk-form-foto'),
                  path: _fotoTampil,
                  ukuran: 96,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto Produk',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          OutlinedButton.icon(
                            key: const Key('produk-form-foto-kamera'),
                            onPressed: () => _pilihFoto(kamera: true),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Kamera'),
                          ),
                          OutlinedButton.icon(
                            key: const Key('produk-form-foto-galeri'),
                            onPressed: () => _pilihFoto(kamera: false),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Galeri'),
                          ),
                          if (_fotoTampil != null)
                            TextButton(
                              key: const Key('produk-form-foto-hapus'),
                              onPressed: () => setState(() {
                                _sumberFoto = null;
                                _fotoDihapus = true;
                              }),
                              child: const Text('Hapus foto'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('produk-form-nama'),
              controller: _nama,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama produk',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Nama produk wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('produk-form-harga'),
              controller: _harga,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Harga Katalog',
                border: const OutlineInputBorder(),
                helperText: hargaTerbaca == null
                    ? 'Tanpa angka desimal'
                    : 'Tampil sebagai ${formatRupiah(hargaTerbaca)}',
              ),
              validator: (value) {
                final harga = parseRupiah(value ?? '');
                if (harga == null) return 'Harga wajib diisi';
                if (harga <= 0) return 'Harga harus lebih dari nol';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('produk-form-satuan'),
              controller: _satuan,
              decoration: const InputDecoration(
                labelText: 'Satuan',
                hintText: 'pcs, kg, liter, bungkus',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Satuan wajib diisi'
                  : null,
            ),
            SwitchListTile(
              key: const Key('produk-form-pecahan'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Boleh dijual pecahan'),
              subtitle: Text(
                _bolehPecahan
                    ? 'Kuantitas boleh 2,5 ${_satuan.text.trim()}'
                    : 'Kuantitas harus bilangan bulat',
              ),
              value: _bolehPecahan,
              onChanged: (value) => setState(() => _bolehPecahan = value),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int?>(
              key: const Key('produk-form-kategori'),
              initialValue: _kategoriId,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tanpa kategori'),
                ),
                for (final item in kategori)
                  DropdownMenuItem<int?>(
                    value: item.id,
                    child: Text(item.nama),
                  ),
              ],
              onChanged: (value) => setState(() => _kategoriId = value),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const Key('produk-form-kategori-baru'),
                onPressed: _buatKategori,
                icon: const Icon(Icons.add),
                label: const Text('Kategori baru'),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('produk-form-simpan'),
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
            if (_mengubah) ...[
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('produk-form-nonaktifkan'),
                onPressed: _ubahStatus,
                child: Text(
                  widget.produk!.aktif ? 'Nonaktifkan' : 'Aktifkan lagi',
                ),
              ),
              BagianStok(produk: widget.produk!),
            ],
          ],
        ),
      ),
    );
  }
}

class _KategoriBaruDialog extends StatefulWidget {
  const _KategoriBaruDialog();

  @override
  State<_KategoriBaruDialog> createState() => _KategoriBaruDialogState();
}

class _KategoriBaruDialogState extends State<_KategoriBaruDialog> {
  final _nama = TextEditingController();
  String? _pesanGalat;

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  void _simpan() {
    final nama = _nama.text.trim();
    if (nama.isEmpty) {
      setState(() => _pesanGalat = 'Nama kategori wajib diisi');
      return;
    }
    Navigator.of(context).pop(nama);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kategori baru'),
      content: TextField(
        key: const Key('kategori-baru-nama'),
        controller: _nama,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Nama kategori',
          errorText: _pesanGalat,
        ),
        onSubmitted: (_) => _simpan(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('kategori-baru-simpan'),
          onPressed: _simpan,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
