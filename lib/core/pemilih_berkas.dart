import 'package:file_selector/file_selector.dart';

/// Pintu masuk satu berkas dari penyimpanan perangkat.
///
/// Dibuat sebagai antarmuka supaya test bisa menjawab tanpa membuka pemilih
/// berkas sungguhan, sama seperti [PemilihGambar] untuk galeri dan kamera.
abstract interface class PemilihBerkas {
  /// Null berarti pengguna menutup pemilih tanpa memilih apa pun.
  Future<String?> pilihBackup();
}

/// Pemilih berkas sungguhan lewat aplikasi berkas bawaan HP.
class PemilihBerkasPerangkat implements PemilihBerkas {
  const PemilihBerkasPerangkat();

  @override
  Future<String?> pilihBackup() async {
    // Hanya ZIP yang ditawarkan: Backup selalu ZIP, dan berkas lain hanya akan
    // ditolak setelah dipilih.
    const zip = XTypeGroup(
      label: 'Backup kasir',
      extensions: ['zip'],
      mimeTypes: ['application/zip'],
    );
    final berkas = await openFile(acceptedTypeGroups: const [zip]);
    return berkas?.path;
  }
}
