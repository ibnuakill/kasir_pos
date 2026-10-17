import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/pemilih_gambar.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/gambar_store.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/features/produk/foto_produk.dart';

import 'bantuan.dart';

/// PNG 1×1 sungguhan supaya `Image.file` tidak perlu berkas biner di repo.
final _pngKecil = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFAAH/'
  'q842iQAAAABJRU5ErkJggg==',
);

class _PemilihPalsu implements PemilihGambar {
  String? galeri;
  String? kamera;
  int galeriDipanggil = 0;
  int kameraDipanggil = 0;

  @override
  Future<String?> dariGaleri() async {
    galeriDipanggil++;
    return galeri;
  }

  @override
  Future<String?> dariKamera() async {
    kameraDipanggil++;
    return kamera;
  }
}

/// Pengganti [GambarStore] tanpa I/O berkas: di dalam widget test, penyalinan
/// berkas sungguhan berjalan di zona waktu palsu dan tidak pernah selesai.
class _GambarPalsu extends GambarStore {
  _GambarPalsu(this.berkas) : super(() async => Directory.systemTemp);

  /// Path yang dikembalikan seolah-olah hasil salinan.
  final String berkas;

  final List<String> namaDipakai = [];
  final List<String?> dihapus = [];

  @override
  Future<String> simpanDari(String sumber, {required String nama}) async {
    namaDipakai.add(nama);
    return berkas;
  }

  @override
  Future<void> hapus(String? path) async {
    dihapus.add(path);
  }
}

void main() {
  late AppDatabase database;
  late Directory sumber;
  late File gambarContoh;
  late _PemilihPalsu pemilih;
  late _GambarPalsu gambar;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');

    sumber = await Directory.systemTemp.createTemp('kasir-foto');
    gambarContoh = File('${sumber.path}/foto.png')..writeAsBytesSync(_pngKecil);
    pemilih = _PemilihPalsu()
      ..galeri = gambarContoh.path
      ..kamera = gambarContoh.path;
    gambar = _GambarPalsu(gambarContoh.path);
  });

  tearDown(() async {
    await database.close();
    if (sumber.existsSync()) sumber.deleteSync(recursive: true);
  });

  /// Formulir Produk memuat bagian foto, jadi layar uji dibuat tinggi supaya
  /// seluruh isinya terbangun tanpa perlu menggulir (menggulir di widget test
  /// mudah tersangkut animasi yang tidak pernah selesai).
  void layarTinggi(WidgetTester tester) {
    tester.view.physicalSize = const Size(500, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> bukaProduk(WidgetTester tester) async {
    layarTinggi(tester);
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
        overrides: [
          pemilihGambarProvider.overrideWithValue(pemilih),
          gambarStoreProvider.overrideWithValue(gambar),
        ],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Produk').last);
    await tester.pumpAndSettle();
  }

  Future<void> bukaForm(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('produk-tambah')));
    await tester.pumpAndSettle();
  }

  Future<void> tekanSimpan(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('produk-form-simpan')));
    await tester.pumpAndSettle();
  }

  Future<void> isiDanSimpan(
    WidgetTester tester, {
    String nama = 'Kopi Bubuk',
    String harga = '15000',
    String satuan = 'pcs',
  }) async {
    await tester.enterText(find.byKey(const Key('produk-form-nama')), nama);
    await tester.enterText(find.byKey(const Key('produk-form-harga')), harga);
    await tester.enterText(find.byKey(const Key('produk-form-satuan')), satuan);
    await tekanSimpan(tester);
  }

  /// Query langsung, bukan langganan `watch()`: stream drift butuh event loop
  /// sungguhan dan menggantung di dalam widget test.
  Future<ProdukData> produkPertama() =>
      database.select(database.produk).getSingle();

  testWidgets('produk baru menyimpan foto dari galeri dan menampilkannya', (
    tester,
  ) async {
    await bukaProduk(tester);
    await bukaForm(tester);

    await tester.tap(find.byKey(const Key('produk-form-foto-galeri')));
    await tester.pumpAndSettle();
    expect(pemilih.galeriDipanggil, 1);

    await isiDanSimpan(tester);

    // Berkas dinamai menurut id Produk, bukan nama berkas asli.
    expect(gambar.namaDipakai, ['produk-1']);
    final produk = await produkPertama();
    expect(produk.foto, gambarContoh.path);

    final kartu = tester.widget<FotoProduk>(
      find.byKey(Key('produk-foto-${produk.id}')),
    );
    expect(kartu.path, gambarContoh.path);

    await tutupAplikasi(tester);
  });

  testWidgets('foto bisa diambil dari kamera', (tester) async {
    await bukaProduk(tester);
    await bukaForm(tester);

    await tester.tap(find.byKey(const Key('produk-form-foto-kamera')));
    await tester.pumpAndSettle();
    expect(pemilih.kameraDipanggil, 1);

    await isiDanSimpan(tester);
    expect((await produkPertama()).foto, gambarContoh.path);

    await tutupAplikasi(tester);
  });

  testWidgets('produk tanpa foto tampil dengan penanda pengganti', (
    tester,
  ) async {
    await bukaProduk(tester);
    await bukaForm(tester);
    await isiDanSimpan(tester);

    final produk = await produkPertama();
    expect(produk.foto, isNull);
    expect(gambar.namaDipakai, isEmpty);

    final penanda = find.byKey(Key('produk-foto-${produk.id}'));
    expect(penanda, findsOneWidget);
    expect(
      find.descendant(
        of: penanda,
        matching: find.byIcon(Icons.inventory_2_outlined),
      ),
      findsOneWidget,
    );

    await tutupAplikasi(tester);
  });

  testWidgets('membatalkan pilihan foto tidak menyimpan apa pun', (
    tester,
  ) async {
    pemilih.galeri = null;

    await bukaProduk(tester);
    await bukaForm(tester);
    await tester.tap(find.byKey(const Key('produk-form-foto-galeri')));
    await tester.pumpAndSettle();

    await isiDanSimpan(tester);

    expect((await produkPertama()).foto, isNull);
    expect(gambar.namaDipakai, isEmpty);

    await tutupAplikasi(tester);
  });

  testWidgets('mengganti foto memakai nama berkas yang sama', (tester) async {
    final id = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    await ProdukStore(database).setFoto(id, '/lama/foto.png');

    await bukaProduk(tester);
    await tester.tap(find.text('Kopi Bubuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('produk-form-foto-galeri')));
    await tester.pumpAndSettle();
    await tekanSimpan(tester);

    // Nama berkas diturunkan dari id, jadi berkas lama tertimpa, bukan
    // menumpuk berkas baru.
    expect(gambar.namaDipakai, ['produk-$id']);
    expect((await ProdukStore(database).cari(id))!.foto, gambarContoh.path);

    await tutupAplikasi(tester);
  });

  testWidgets('hapus foto membuang berkas dan rujukannya', (tester) async {
    final id = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    await ProdukStore(database).setFoto(id, '/lama/foto.png');

    await bukaProduk(tester);
    await tester.tap(find.text('Kopi Bubuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('produk-form-foto-hapus')));
    await tester.pumpAndSettle();
    await tekanSimpan(tester);

    expect(gambar.dihapus, ['/lama/foto.png']);
    expect((await ProdukStore(database).cari(id))!.foto, isNull);

    final penanda = find.byKey(Key('produk-foto-$id'));
    expect(
      find.descendant(
        of: penanda,
        matching: find.byIcon(Icons.inventory_2_outlined),
      ),
      findsOneWidget,
    );

    await tutupAplikasi(tester);
  });

  testWidgets('katalog kasir menampilkan Foto Produk', (tester) async {
    final id = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi Bubuk', hargaKatalog: 15000, satuan: 'pcs');
    await ProdukStore(database).setFoto(id, gambarContoh.path);
    await StokStore(database).tambahStok(
      id,
      jumlahMili: 5000,
      waktu: DateTime(2026, 10, 17, 9),
    );

    await bukaProduk(tester);
    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();

    final kartu = tester.widget<FotoProduk>(
      find.byKey(Key('kasir-foto-$id')),
    );
    expect(kartu.path, gambarContoh.path);

    await tutupAplikasi(tester);
  });
}
