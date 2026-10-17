# 16: Backup impor

**What to build:** Berkas Backup bisa dipilih, menimpa seluruh data setelah dikonfirmasi, dan memulihkan katalog, Stok, Transaksi, serta Foto Produk seperti saat diekspor.

**Blocked by:** 15 (Backup ekspor)

**Status:** done

- [x] Berkas Backup bisa dipilih dari penyimpanan perangkat
- [x] Konfirmasi ditampilkan sebelum data yang ada ditimpa, dan membatalkannya tidak mengubah apa pun
- [x] Setelah impor, daftar Produk, angka Stok, dan daftar Transaksi sama dengan saat diekspor
- [x] Foto Produk dan gambar QR ikut pulih
- [x] Berkas yang bukan Backup ditolak dengan pesan yang jelas, tanpa merusak data yang sudah ada

## Comments

**2026-10-17** — `PemilihBerkas` (antarmuka baru, `file_selector` di baliknya) memilih ZIP; konfirmasi "Timpa seluruh data?" muncul sebelum apa pun berubah. `BackupStore.pulihkan(path)` memeriksa ZIP + `backup.json` lebih dulu (`IsiBackup.dariJson`, `BackupTidakSahException` berpesan bahasa Indonesia), baru menaruh gambar (`GambarStore.bersihkan` lalu tulis ulang), lalu menimpa database dalam satu transaksi: hapus dari tabel paling hilir, sisip dari paling hulu. Foto Produk & gambar QRIS disimpan sebagai path mutlak, jadi path-nya ditulis ulang ke folder gambar perangkat ini (`_pathBaru`) — tanpa itu foto hilang saat Backup dipulihkan di HP lain. `versi` Backup yang lebih baru ditolak. Antarmuka `PembuatBackup` menjadi `BackupKasir` (+`pulihkan`). Setelah impor, provider katalog, stok, laporan, QRIS, Toko, tanggal Backup, dan Keranjang dibaca ulang. 151 test lulus (8 baru).
