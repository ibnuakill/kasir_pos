# 15: Backup ekspor

**What to build:** Seluruh data — Data Toko, Kategori, Produk, Foto Produk, riwayat Stok, Transaksi, dan gambar QR — dikemas menjadi satu berkas ZIP yang bisa dibagikan lewat lembar berbagi sistem.

**Blocked by:** 06 (Foto Produk), 13 (Detail Transaksi dan Transaksi Batal)

**Status:** done

- [x] Ekspor menghasilkan satu berkas ZIP yang bisa dibagikan lewat lembar berbagi sistem
- [x] Berkas itu memuat Produk, Kategori, Foto Produk, riwayat Stok, Transaksi, dan Data Toko
- [x] Gambar QR toko ikut di dalamnya
- [x] Tanggal Backup terakhir tercatat dan tampil di Pengaturan
- [x] Ekspor tidak mengubah data yang sedang ada

## Comments

**2026-10-17** — ZIP `kasir-backup-YYYYMMDD-HHmm.zip` berisi `backup.json` + `gambar/…`. Tabel disimpan sebagai baris JSON apa adanya (nama kolom database), bukan kelas Dart, supaya kolom baru tidak terlupa; `IsiBackup.urutanTabel` ikut dependensi FK dan dijaga test yang membandingkannya dengan `database.allTables`. `versiSekarang = 1`. Berbagi lewat `Pembagi.bagikanBerkas` (method baru di antarmuka) memakai `share_plus`; `archive` dipakai untuk `ZipEncoder`. `BackupStore` sekarang `implements PembuatBackup` supaya layar Pengaturan bisa diuji tanpa menulis berkas sungguhan — penulisan berkas nyata tidak berjalan di jam palsu `testWidgets`, jadi test layar memakai `_BackupPalsu` dan isi ZIP diuji di `test()` biasa. Tanggal terakhir disimpan di `app_settings` (`backup.terakhir`) dan ditampilkan di kartu Backup. 143 test lulus (9 baru).
