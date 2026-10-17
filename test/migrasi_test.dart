import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/stok_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/data/transaksi_store.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('database versi 1 naik ke versi 2 tanpa kehilangan Data Toko', () async {
    final dir = Directory.systemTemp.createTempSync('kasir_migrasi');
    addTearDown(() => dir.deleteSync(recursive: true));
    final berkas = File(p.join(dir.path, 'kasir.sqlite'));

    // Skema versi 1, ditulis tangan seperti yang sudah terpasang di perangkat.
    final lama = sqlite3.open(berkas.path);
    lama.execute(
      'CREATE TABLE app_settings ('
      '"key" TEXT NOT NULL, "value" TEXT NOT NULL, PRIMARY KEY ("key"))',
    );
    lama.execute(
      "INSERT INTO app_settings (\"key\", \"value\") "
      "VALUES ('toko.nama', 'Warung Lama')",
    );
    lama.execute('PRAGMA user_version = 1');
    lama.close();

    final database = AppDatabase(NativeDatabase(berkas));
    addTearDown(database.close);

    final toko = await TokoStore(database).baca();
    expect(toko, isNotNull);
    expect(toko!.nama, 'Warung Lama');

    // Tabel yang baru ditambahkan di versi berikutnya ikut terpasang.
    final produk = await ProdukStore(
      database,
    ).tambah(nama: 'Kopi', hargaKatalog: 15000, satuan: 'pcs');
    expect(await ProdukStore(database).watch().first, hasLength(1));

    await StokStore(
      database,
    ).tambahStok(produk, jumlahMili: 5000, waktu: DateTime(2026, 10, 17));
    expect(
      (await StokStore(database).watchTotalPerProduk().first)[produk],
      5000,
    );

    // Tabel Transaksi juga ikut terpasang, dan Produk lama bisa langsung
    // dijual tanpa menyentuh data yang sudah ada.
    final terjual = await TransaksiStore(database).simpan(
      waktu: DateTime(2026, 10, 17, 10),
      metodeBayar: MetodeBayar.tunai,
      baris: [
        BarisTerjual(
          produk: (await ProdukStore(database).cari(produk))!,
          kuantitasMili: 1000,
        ),
      ],
      uangDiterima: 20000,
    );
    expect(terjual.nomor, 'TRX-20261017-001');
    expect(terjual.kembalian, 5000);
  });

  test('database versi 2 mendapat kolom foto tanpa kehilangan Produk', () async {
    final dir = Directory.systemTemp.createTempSync('kasir_migrasi');
    addTearDown(() => dir.deleteSync(recursive: true));
    final berkas = File(p.join(dir.path, 'kasir.sqlite'));

    // Skema versi 2: Produk sudah ada, kolom foto belum.
    final lama = sqlite3.open(berkas.path);
    lama.execute(
      'CREATE TABLE app_settings ('
      '"key" TEXT NOT NULL, "value" TEXT NOT NULL, PRIMARY KEY ("key"))',
    );
    lama.execute(
      'CREATE TABLE kategori ('
      '"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"nama" TEXT NOT NULL)',
    );
    lama.execute(
      'CREATE TABLE produk ('
      '"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '"nama" TEXT NOT NULL, "harga_katalog" INTEGER NOT NULL, '
      '"satuan" TEXT NOT NULL, '
      '"boleh_pecahan" INTEGER NOT NULL DEFAULT 0 '
      'CHECK ("boleh_pecahan" IN (0, 1)), '
      '"kategori_id" INTEGER NULL REFERENCES kategori ("id"), '
      '"aktif" INTEGER NOT NULL DEFAULT 1 CHECK ("aktif" IN (0, 1)))',
    );
    lama.execute(
      "INSERT INTO produk (nama, harga_katalog, satuan) "
      "VALUES ('Kopi Lama', 12000, 'pcs')",
    );
    lama.execute('PRAGMA user_version = 2');
    lama.close();

    final database = AppDatabase(NativeDatabase(berkas));
    addTearDown(database.close);

    final produk = await database.select(database.produk).getSingle();
    expect(produk.nama, 'Kopi Lama');
    // Produk lama belum punya foto, dan itu keadaan yang sah.
    expect(produk.foto, isNull);

    await ProdukStore(database).setFoto(produk.id, '/gambar/kopi.png');
    expect(
      (await database.select(database.produk).getSingle()).foto,
      '/gambar/kopi.png',
    );
  });
}
