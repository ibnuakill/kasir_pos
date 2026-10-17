import 'dart:convert';

import 'package:kasir/core/diskon.dart';
import 'package:kasir/data/database.dart';

/// Satu baris Keranjang sebagaimana disimpan: hanya id Produk dan Kuantitas.
///
/// Nama, Harga Katalog, dan satuannya sengaja tidak ikut disimpan: saat
/// Keranjang dipulihkan, barisnya dibaca ulang dari katalog supaya harga yang
/// dipakai selalu harga yang berlaku (user story 36), bukan harga kemarin.
class BarisKeranjangTersimpan {
  const BarisKeranjangTersimpan({
    required this.produkId,
    required this.kuantitasMili,
  });

  final int produkId;
  final int kuantitasMili;

  Map<String, Object?> keJson() => {
    'produk': produkId,
    'kuantitas': kuantitasMili,
  };

  static BarisKeranjangTersimpan? dariJson(Object? isi) {
    if (isi is! Map) return null;
    final produkId = isi['produk'];
    final kuantitasMili = isi['kuantitas'];
    if (produkId is! int || kuantitasMili is! int) return null;
    if (kuantitasMili <= 0) return null;
    return BarisKeranjangTersimpan(
      produkId: produkId,
      kuantitasMili: kuantitasMili,
    );
  }
}

/// Keranjang yang tersimpan di antara dua kali aplikasi dibuka, termasuk
/// Diskon yang menempel padanya.
class IsiKeranjangTersimpan {
  const IsiKeranjangTersimpan({required this.baris, this.diskon});

  final List<BarisKeranjangTersimpan> baris;
  final Diskon? diskon;

  Map<String, Object?> keJson() => {
    'baris': [for (final satu in baris) satu.keJson()],
    'diskon': diskon == null
        ? null
        : {'jenis': diskon!.jenis.name, 'nilai': diskon!.nilai},
  };

  static IsiKeranjangTersimpan? dariJson(Object? isi) {
    if (isi is! Map) return null;
    final baris = [
      for (final satu in (isi['baris'] as List? ?? const []))
        ?BarisKeranjangTersimpan.dariJson(satu),
    ];
    if (baris.isEmpty) return null;

    return IsiKeranjangTersimpan(
      baris: baris,
      diskon: _diskonDariJson(isi['diskon']),
    );
  }

  static Diskon? _diskonDariJson(Object? isi) {
    if (isi is! Map) return null;
    final jenis = JenisDiskon.values
        .where((satu) => satu.name == isi['jenis'])
        .firstOrNull;
    final nilai = isi['nilai'];
    if (jenis == null || nilai is! int || nilai < 0) return null;
    return Diskon(jenis: jenis, nilai: nilai);
  }
}

/// Menyimpan satu-satunya Keranjang aktif (user story 40, 41) di baris
/// `app_settings`.
///
/// Keranjang sengaja disimpan sebagai satu potong JSON, bukan tabel tersendiri:
/// isinya cuma state layar kasir yang dibaca dan ditulis utuh setiap kali
/// berubah, tidak pernah ditanyakan per baris, dan bentuknya boleh berubah
/// tanpa migrasi skema. Keranjang yang bentuknya tidak dikenali dibaca sebagai
/// "tidak ada Keranjang" — lebih baik mulai kosong daripada gagal membuka
/// aplikasi.
class KeranjangStore {
  const KeranjangStore(this._db);

  static const kunci = 'keranjang.aktif';

  final AppDatabase _db;

  Future<IsiKeranjangTersimpan?> baca() async {
    final teks = await _db.getSetting(kunci);
    if (teks == null || teks.trim().isEmpty) return null;

    try {
      return IsiKeranjangTersimpan.dariJson(jsonDecode(teks));
    } on FormatException {
      return null;
    }
  }

  Future<void> simpan(IsiKeranjangTersimpan isi) =>
      _db.setSetting(kunci, jsonEncode(isi.keJson()));

  Future<void> hapus() async {
    await (_db.delete(_db.appSettings)..where((t) => t.key.equals(kunci))).go();
  }
}
