import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Mengubah widget yang sedang tampil di balik [kunci] menjadi PNG.
///
/// Skala 3 dipakai supaya gambar tetap tajam saat dibuka di HP lain; Struk
/// memang hanya hidup sebagai gambar, tidak ada format teks.
Future<Uint8List> gambarStrukPng(GlobalKey kunci, {double skala = 3}) async {
  final objek = kunci.currentContext?.findRenderObject();
  if (objek is! RenderRepaintBoundary) {
    throw StateError('Struk belum tampil, jadi belum bisa digambar');
  }

  final gambar = await objek.toImage(pixelRatio: skala);
  try {
    final data = await gambar.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) {
      throw StateError('Gambar Struk kosong');
    }
    return data.buffer.asUint8List();
  } finally {
    gambar.dispose();
  }
}
