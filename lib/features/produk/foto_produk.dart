import 'dart:io';

import 'package:flutter/material.dart';

/// Foto Produk, atau penanda pengganti kalau Produk belum punya foto.
///
/// Berkas yang sudah hilang dari penyimpanan juga jatuh ke penanda pengganti,
/// supaya katalog tidak pernah menampilkan kotak gambar rusak.
class FotoProduk extends StatelessWidget {
  const FotoProduk({super.key, required this.path, this.ukuran = 56});

  /// Path berkas di penyimpanan aplikasi; null berarti belum ada foto.
  final String? path;

  /// Sisi kotak dalam piksel; null berarti mengisi ruang yang tersedia.
  final double? ukuran;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    // null = mengisi ruang yang tersedia, jadi batasnya datang dari induk.
    final lebar = ukuran ?? double.infinity;
    final tinggi = ukuran ?? double.infinity;

    final pengganti = Container(
      width: lebar,
      height: tinggi,
      color: skema.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.inventory_2_outlined,
        size: ukuran == null ? 32 : ukuran! * 0.4,
        color: skema.onSurfaceVariant,
      ),
    );

    final berkas = path;
    if (berkas == null || berkas.isEmpty) return pengganti;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(berkas),
        width: lebar,
        height: tinggi,
        fit: BoxFit.cover,
        errorBuilder: (context, _, _) => pengganti,
      ),
    );
  }
}
