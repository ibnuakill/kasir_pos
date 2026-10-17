import 'rupiah.dart';

/// Bentuk Diskon yang bisa dipasang pada satu Transaksi.
enum JenisDiskon { nominal, persen }

/// Potongan harga di level Transaksi — bukan per baris. `nilai` adalah rupiah
/// bulat untuk [JenisDiskon.nominal], atau persen bilangan bulat 0–100 untuk
/// [JenisDiskon.persen].
class Diskon {
  const Diskon({required this.jenis, required this.nilai});

  final JenisDiskon jenis;
  final int nilai;

  @override
  bool operator ==(Object other) =>
      other is Diskon && other.jenis == jenis && other.nilai == nilai;

  @override
  int get hashCode => Object.hash(jenis, nilai);

  @override
  String toString() => 'Diskon(${jenis.name}, $nilai)';
}

/// Potongan yang benar-benar dipakai, dijepit ke rentang 0..subtotal supaya
/// Total tidak pernah jadi angka minus (user story 39).
///
/// Persen dibulatkan ke rupiah terdekat dengan aritmetika bulat — tidak ada
/// `double` di jalur uang.
int hitungPotongan(int subtotal, Diskon? diskon) {
  if (diskon == null || subtotal <= 0) return 0;

  final potongan = switch (diskon.jenis) {
    JenisDiskon.nominal => diskon.nilai,
    JenisDiskon.persen => (subtotal * diskon.nilai + 50) ~/ 100,
  };

  return potongan.clamp(0, subtotal);
}

/// Total = Subtotal − Diskon.
int hitungTotal(int subtotal, Diskon? diskon) =>
    subtotal - hitungPotongan(subtotal, diskon);

/// Teks Diskon sebagaimana kasir menuliskannya: "Rp5.000" atau "10%".
String formatDiskon(Diskon diskon) => switch (diskon.jenis) {
  JenisDiskon.nominal => formatRupiah(diskon.nilai),
  JenisDiskon.persen => '${diskon.nilai}%',
};

/// Aturan isian dialog Diskon.
String? validasiDiskon(String? teks, {required JenisDiskon jenis}) {
  final isi = (teks ?? '').trim();
  if (isi.isEmpty) return 'Diskon wajib diisi';

  final nilai = jenis == JenisDiskon.nominal
      ? parseRupiah(isi)
      : int.tryParse(isi.replaceAll(RegExp(r'[^0-9]'), ''));

  if (nilai == null) return 'Diskon tidak dikenali';
  if (nilai < 0) return 'Diskon tidak boleh negatif';
  if (jenis == JenisDiskon.persen && nilai > 100) {
    return 'Persen paling banyak 100';
  }
  return null;
}
