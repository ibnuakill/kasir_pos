/// Kuantitas disimpan sebagai bilangan bulat berskala seribu, supaya 0,75 liter
/// tidak kehilangan presisi seperti pada floating point.
const int skalaKuantitas = 1000;

/// Menampilkan kuantitas dengan koma desimal dan tanpa nol berekor:
/// 2500 → "2,5", 10000 → "10".
String formatKuantitas(int mili) {
  final negatif = mili < 0;
  final nilai = mili.abs();
  final bulat = nilai ~/ skalaKuantitas;
  final sisa = nilai % skalaKuantitas;

  var teks = '$bulat';
  if (sisa != 0) {
    final desimal = sisa
        .toString()
        .padLeft(3, '0')
        .replaceFirst(RegExp(r'0+$'), '');
    teks = '$teks,$desimal';
  }

  return negatif ? '-$teks' : teks;
}

/// Membaca tulisan kasir: "10", "2,5", atau "2.5". Lebih dari tiga angka
/// desimal ditolak, karena itu batas ketelitian yang disimpan.
int? parseKuantitas(String teks) {
  var bersih = teks.trim().replaceAll(' ', '');
  if (bersih.isEmpty) return null;

  final negatif = bersih.startsWith('-');
  if (negatif) bersih = bersih.substring(1);

  final bagian = bersih.replaceAll('.', ',').split(',');
  if (bagian.length > 2) return null;

  final bulat = bagian.first.isEmpty ? '0' : bagian.first;
  if (!RegExp(r'^\d+$').hasMatch(bulat)) return null;

  var desimal = bagian.length == 2 ? bagian[1] : '';
  if (desimal.isNotEmpty && !RegExp(r'^\d{1,3}$').hasMatch(desimal)) {
    return null;
  }
  desimal = desimal.padRight(3, '0');

  final nilai =
      int.parse(bulat) * skalaKuantitas + (desimal.isEmpty ? 0 : int.parse(desimal));
  return negatif ? -nilai : nilai;
}
