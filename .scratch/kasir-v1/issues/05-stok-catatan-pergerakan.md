# 05: Stok sebagai catatan pergerakan

**What to build:** Stok bergerak lewat catatan, bukan angka yang ditimpa. Tambah Stok dan Koreksi Stok mencatat setiap perubahan beserta tanggalnya, riwayat pergerakan bisa dilihat per Produk, dan angka Stok yang tampil adalah hasil perhitungan dari catatan itu.

**Blocked by:** 04 (Katalog — Produk dan Kategori)

**Status:** done

- [x] Tambah Stok mencatat jumlah dan tanggal, dan angka Stok Produk naik sebesar itu
- [x] Koreksi Stok menyesuaikan angka Stok tanpa menghapus catatan sebelumnya
- [x] Riwayat pergerakan sebuah Produk menampilkan setiap perubahan beserta jenis dan tanggalnya
- [x] Angka Stok tidak pernah tampil negatif
- [x] Produk baru mendapat Stok awal lewat Tambah Stok pertama, bukan angka yang diketik langsung

## Comments

**2026-10-17 — selesai.** `flutter analyze` bersih, **42 test lulus** (40 sebelumnya + 2 test lapisan data di berkas ini).

Bentuknya:

- Tabel `pergerakan_stok` menyimpan `produk_id`, `jenis`, `jumlah_mili`, `waktu`. Tidak ada kolom Stok di tabel Produk — angkanya memang tidak pernah disimpan (ADR-0003). Skema naik 2 → 3, dan `test/migrasi_test.dart` sekarang juga menambah Stok setelah naik versi, jadi jalur migrasi ikut teruji sampai tabel baru.
- `StokStore.watchTotalPerProduk` menjumlahkan dengan `GROUP BY` di database, bukan dengan memuat semua catatan lalu menjumlahkan di memori. `watchPergerakan(produkId)` memberi riwayat satu Produk, terbaru di atas.
- Kuantitas disimpan sebagai bilangan bulat berskala seribu (`lib/core/kuantitas.dart`), jadi 0,75 liter tidak kehilangan presisi dan tidak ada `double` di jalur uang maupun Stok.
- Bagian Stok duduk di layar Produk: angka sekarang, dua tombol, dan riwayat. Daftar katalog juga menampilkan `stok 10` di subjudul tiap baris.

Keputusan yang saya ambil:

- **Koreksi Stok mencatat selisihnya, bukan angka barunya.** Kasir mengetik hasil hitung fisik (misalnya 7), yang tersimpan adalah −3, sehingga riwayatnya tetap bisa dibaca: sebelumnya 10, sekarang 7. Kalau yang disimpan angka baru, catatan itu jadi omong kosong karena tidak lagi terhubung ke catatan lain.
- **Koreksi ke angka yang sama tidak menulis catatan apa pun.** Baris berjumlah nol hanya jadi kebisingan di riwayat.
- **Penolakan angka negatif ada di `StokStore`, bukan cuma di validator.** Validator bisa dilewati; lapisan data tidak. Ada test yang memanggil store langsung dengan angka negatif dan mengharapkan `ArgumentError`.
- **`jenis` menyimpan teks, bukan nomor urut enum.** Supaya Backup (tiket 15) tetap terbaca manusia dan menambah jenis baru tidak pernah menggeser arti data lama. `penjualan` dan `pembatalan` sudah ada di daftar walau baru dipakai tiket 09 dan 13.
- **Tambah Stok pertama pada Produk baru adalah stok awal.** Formulir Produk baru tidak punya kolom Stok sama sekali, jadi tidak ada jalan pintas mengisi angka yang tidak bisa dipertanggungjawabkan.

Catatan yang belum ditutup:

- Penjualan belum mengurangi Stok — itu tiket 09. Sampai tiket itu selesai, Stok hanya bergerak lewat dua tombol ini.
- Riwayat hanya bisa dilihat per Produk. Belum ada layar "semua pergerakan" lintas Produk.
- Koreksi Stok tidak menyimpan alasan (barang rusak, hilang, salah hitung). Kalau nanti dibutuhkan, itu kolom baru di tabel yang sama.
- Tombol Stok berada di bawah formulir, jadi di layar HP perlu digulir dulu. Kalau terasa jauh saat dipakai, memindahkan Bagian Stok ke atas tombol Simpan adalah perubahan satu baris.
