import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/struk/gambar_struk.dart';

/// Menggambar Struk di [kunci] lalu menyerahkannya ke lembar berbagi sistem.
///
/// Mengembalikan true bila gambar berhasil diserahkan. Kegagalan apa pun
/// (lembar berbagi tidak tersedia, gambar belum siap) berakhir jadi pesan di
/// layar, bukan galat yang dilempar ke atas.
Future<bool> bagikanStruk({
  required WidgetRef ref,
  required BuildContext context,
  required GlobalKey kunci,
  required TransaksiData transaksi,
}) async {
  try {
    final png = await gambarStrukPng(kunci);
    await ref
        .read(pembagiProvider)
        .bagikanGambar(
          png,
          namaBerkas: 'struk-${transaksi.nomor}.png',
          teks: 'Struk ${transaksi.nomor}',
        );
    return true;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Struk gagal dibagikan')));
    }
    return false;
  }
}
