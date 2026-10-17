import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/features/pin/pin_gate.dart';

/// Isi Pengaturan. Tab ini hanya sampai ke sini setelah PIN benar, dijaga oleh
/// gerbang di [HomeShell].
class PengaturanScreen extends ConsumerWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toko = ref.watch(tokoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: toko.when(
        loading: () => const SizedBox.shrink(),
        error: (error, _) =>
            Center(child: Text('Gagal memuat Data Toko: $error')),
        data: (toko) {
          if (toko == null) {
            return const Center(child: Text('Data Toko belum diisi'));
          }
          return _IsiPengaturan(toko: toko);
        },
      ),
    );
  }
}

class _IsiPengaturan extends ConsumerStatefulWidget {
  const _IsiPengaturan({required this.toko});

  final Toko toko;

  @override
  ConsumerState<_IsiPengaturan> createState() => _IsiPengaturanState();
}

class _IsiPengaturanState extends ConsumerState<_IsiPengaturan> {
  final _formKey = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.toko.nama);
  late final _alamat = TextEditingController(text: widget.toko.alamat);

  @override
  void dispose() {
    _nama.dispose();
    _alamat.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await TokoStore(ref.read(databaseProvider)).simpan(
      Toko(nama: _nama.text.trim(), alamat: _alamat.text.trim()),
    );

    if (!mounted) return;
    ref.invalidate(tokoProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: const Key('data-toko-nama'),
            controller: _nama,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nama toko',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Nama toko wajib diisi'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('data-toko-alamat'),
            controller: _alamat,
            decoration: const InputDecoration(
              labelText: 'Alamat',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('data-toko-simpan'),
            onPressed: _simpan,
            child: const Text('Simpan Data Toko'),
          ),
          const Divider(height: 40),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('PIN'),
            subtitle: const Text(
              'Diminta saat membuka Pengaturan dan membatalkan transaksi.',
            ),
            trailing: TextButton(
              key: const Key('ganti-pin'),
              onPressed: () => ubahPin(context),
              child: const Text('Ganti PIN'),
            ),
          ),
        ],
      ),
    );
  }
}
