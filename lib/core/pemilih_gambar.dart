import 'package:image_picker/image_picker.dart';

/// Satu-satunya jalan aplikasi meminta gambar dari luar.
///
/// Dibuat sebagai antarmuka supaya test bisa menjawab tanpa kamera atau galeri
/// sungguhan, dan supaya tiket lain (Foto Produk) memakai pintu yang sama.
abstract interface class PemilihGambar {
  /// Null berarti pengguna menutup galeri tanpa memilih apa pun.
  Future<String?> dariGaleri();

  /// Null berarti pengguna membatalkan pengambilan foto.
  Future<String?> dariKamera();
}

/// Pemilih gambar sungguhan lewat aplikasi galeri atau kamera bawaan HP.
class PemilihGambarPerangkat implements PemilihGambar {
  const PemilihGambarPerangkat();

  @override
  Future<String?> dariGaleri() => _ambil(ImageSource.gallery);

  @override
  Future<String?> dariKamera() => _ambil(ImageSource.camera);

  Future<String?> _ambil(ImageSource sumber) async {
    // Diperkecil dulu: gambar QRIS dan Foto Produk tidak perlu resolusi penuh,
    // dan berkas besar membuat Backup ZIP membengkak.
    final hasil = await ImagePicker().pickImage(
      source: sumber,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    return hasil?.path;
  }
}
