import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

/// Pintu keluar ke lembar berbagi sistem. Dibuat sebagai antarmuka supaya test
/// bisa memeriksa apa yang dibagikan tanpa membuka lembar berbagi sungguhan.
abstract interface class Pembagi {
  /// Membagikan satu gambar PNG beserta teks pendampingnya.
  Future<void> bagikanGambar(
    Uint8List png, {
    required String namaBerkas,
    required String teks,
  });
}

/// Pembagi sungguhan: menyerahkan berkas ke aplikasi lain lewat lembar berbagi
/// bawaan HP (user story 57).
class PembagiSistem implements Pembagi {
  const PembagiSistem();

  @override
  Future<void> bagikanGambar(
    Uint8List png, {
    required String namaBerkas,
    required String teks,
  }) async {
    // Dikirim dari data, bukan dari berkas sementara: tidak ada berkas yang
    // perlu dibersihkan setelah lembar berbagi ditutup.
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(png, mimeType: 'image/png')],
        fileNameOverrides: [namaBerkas],
        text: teks,
      ),
    );
  }
}
