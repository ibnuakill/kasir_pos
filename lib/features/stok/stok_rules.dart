import '../../core/kuantitas.dart';

/// Aturan jumlah Stok yang dipakai dialog Tambah Stok dan Koreksi Stok.
///
/// [bolehNol] membedakan keduanya: menambah nol Stok tidak ada artinya,
/// sedangkan mengoreksi ke nol berarti barangnya habis dan itu sah.
String? validasiJumlahStok(
  String? teks, {
  required bool bolehPecahan,
  required bool bolehNol,
}) {
  final nilai = parseKuantitas(teks ?? '');
  if (nilai == null) {
    return (teks ?? '').trim().isEmpty
        ? 'Jumlah wajib diisi'
        : 'Jumlah tidak dikenali';
  }
  if (nilai < 0) return 'Stok tidak boleh negatif';
  if (nilai == 0 && !bolehNol) return 'Jumlah harus lebih dari nol';
  if (!bolehPecahan && nilai % skalaKuantitas != 0) {
    return 'Satuan ini harus bilangan bulat';
  }
  return null;
}
