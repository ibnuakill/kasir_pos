import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/produk_store.dart';
import 'package:kasir/data/toko_store.dart';
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

    // Tabel yang baru ditambahkan di versi 2 ikut terpasang.
    await ProdukStore(
      database,
    ).tambah(nama: 'Kopi', hargaKatalog: 15000, satuan: 'pcs');
    expect(await ProdukStore(database).watch().first, hasLength(1));
  });
}
