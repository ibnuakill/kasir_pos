# 06: Foto Produk

**What to build:** Foto Produk bisa diambil dari kamera atau dipilih dari galeri, tersimpan bersama Produk, dan tampil di katalog. Produk tanpa Foto Produk tetap tampil rapi.

**Blocked by:** 04 (Katalog — Produk dan Kategori)

**Status:** done

- [x] Foto bisa diambil dari kamera atau dipilih dari galeri saat membuat atau mengubah Produk
- [x] Foto yang tersimpan tampil di daftar Produk dan di katalog kasir
- [x] Produk tanpa Foto Produk tampil dengan penanda pengganti, bukan ruang kosong rusak
- [x] Mengganti Foto Produk menggantikan yang lama, bukan menumpuk berkas baru

## Comments

**2026-10-17** — Selesai. 102 test lulus (7 baru di `test/foto_produk_test.dart`, 1 migrasi baru), `flutter analyze` bersih.

- Kolom `produk.foto` (path berkas, nullable) masuk lewat skema **v5**: `m.addColumn` hanya dijalankan kalau tabelnya sudah ada, karena jalur `from < 2` membuat tabel Produk lengkap dengan kolom baru.
- Foto disalin ke `<appSupport>/gambar` lewat `GambarStore` yang sudah dipakai tiket 10, dengan nama `produk-<id>`. Nama diturunkan dari id, jadi mengganti foto menimpa berkas lama — bukan menumpuk. Karena itu penyalinan terjadi **setelah** Produk tersimpan (id baru ada saat itu), lewat `ProdukStore.setFoto`.
- `FotoProduk` (`lib/features/produk/foto_produk.dart`) dipakai tiga tempat: formulir, daftar Produk, dan kartu katalog kasir. Produk tanpa foto — atau yang berkasnya hilang — jatuh ke penanda pengganti (kotak + ikon), bukan kotak gambar rusak.
- Kartu katalog kasir sekarang bergambar di atas, lalu nama (satu baris), harga, dan stok.
- Widget test tidak menyentuh berkas sungguhan: `pemilihGambarProvider` dan `gambarStoreProvider` diganti tiruan lewat `KasirApp.overrides`. Penyalinan berkas asli diuji di `test/qris_test.dart` (test biasa, bukan widget test).
- Layar uji di `produk_test.dart` dan `stok_test.dart` dibuat tinggi (500×2000) karena formulir kini lebih panjang; ini lebih tahan lama daripada menggulir di test.
- Untuk tiket 15 (Backup): berkas Foto Produk ada di folder `gambar/`, bukan di database — ekspor harus ikut menyalin foldernya.
