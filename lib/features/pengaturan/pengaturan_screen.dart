import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';

/// Data Toko yang tersimpan, atau null bila wizard belum pernah dijalankan.
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
          return ListView(
            children: [
              ListTile(
                title: const Text('Nama toko'),
                subtitle: Text(toko.nama),
              ),
              ListTile(
                title: const Text('Alamat'),
                subtitle: Text(toko.alamat),
              ),
            ],
          );
        },
      ),
    );
  }
}
