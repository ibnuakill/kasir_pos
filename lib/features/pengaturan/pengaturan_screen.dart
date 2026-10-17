import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/qris_store.dart';
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
  bool _membuatBackup = false;
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

  /// Mengganti gambar QRIS lama, bukan menumpuk berkas baru.
  Future<void> _pilihGambarQris() async {
    final sumber = await ref.read(pemilihGambarProvider).dariGaleri();
    if (sumber == null) return;

    final path = await ref
        .read(gambarStoreProvider)
        .simpanDari(sumber, nama: 'qris');
    await QrisStore(ref.read(databaseProvider)).simpan(path);

    if (!mounted) return;
    ref.invalidate(gambarQrisProvider);
  }

  Future<void> _hapusGambarQris() async {
    final qris = QrisStore(ref.read(databaseProvider));
    final lama = await qris.baca();
    await qris.hapus();
    await ref.read(gambarStoreProvider).hapus(lama);

    if (!mounted) return;
    ref.invalidate(gambarQrisProvider);
  }

  /// Membuat Backup ZIP lalu menyerahkannya ke lembar berbagi sistem
  /// (user story 71, 73). Tanggalnya dicatat supaya Pengaturan bisa
  /// menunjukkannya (user story 76).
  Future<void> _ekspor() async {
    setState(() => _membuatBackup = true);
    try {
      final berkas = await ref
          .read(backupStoreProvider)
          .ekspor(waktu: ref.read(clockProvider)());
      await ref
          .read(pembagiProvider)
          .bagikanBerkas(
            berkas.path,
            namaBerkas: berkas.uri.pathSegments.last,
            teks: 'Backup data kasir',
          );

      if (!mounted) return;
      ref.invalidate(backupTerakhirProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup siap dibagikan')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup gagal dibuat')),
      );
    } finally {
      if (mounted) setState(() => _membuatBackup = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    final gambarQris = ref.watch(gambarQrisProvider);
    final backupTerakhir = ref.watch(backupTerakhirProvider);

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
          const Divider(height: 40),
          Text('Gambar QRIS', style: teks.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Ditampilkan ke pembeli saat kasir memilih QRIS.',
            style: teks.bodySmall,
          ),
          const SizedBox(height: 12),
          gambarQris.when(
            loading: () => const SizedBox(height: 24),
            error: (error, _) => Text('Gagal memuat gambar QR: $error'),
            data: (path) => path == null
                ? Text(
                    'Belum ada gambar QR.',
                    key: const Key('qris-belum-ada'),
                    style: teks.bodyMedium,
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.file(
                      File(path),
                      key: const Key('qris-gambar'),
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, _) =>
                          const Text('Gambar QR tidak bisa dibaca'),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.tonal(
                key: const Key('qris-pilih'),
                onPressed: _pilihGambarQris,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(width: 8),
              if (gambarQris.valueOrNull != null)
                TextButton(
                  key: const Key('qris-hapus'),
                  onPressed: _hapusGambarQris,
                  child: const Text('Hapus'),
                ),
            ],
          ),
          const Divider(height: 40),
          Text('Backup', style: teks.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Seluruh data toko — katalog, Foto Produk, riwayat Stok, Transaksi, '
            'dan gambar QR — dikemas menjadi satu berkas ZIP.',
            style: teks.bodySmall,
          ),
          const SizedBox(height: 8),
          backupTerakhir.when(
            loading: () => const SizedBox(height: 20),
            error: (error, _) => Text('Gagal membaca tanggal Backup: $error'),
            data: (waktu) => Text(
              waktu == null
                  ? 'Belum pernah membuat Backup.'
                  : 'Backup terakhir: ${formatTanggal(waktu)} ${formatJam(waktu)}',
              key: const Key('backup-terakhir'),
              style: teks.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.tonal(
                key: const Key('backup-ekspor'),
                onPressed: _membuatBackup ? null : _ekspor,
                child: _membuatBackup
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Ekspor Backup'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
