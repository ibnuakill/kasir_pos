# 04: Katalog — Produk dan Kategori

**What to build:** Katalog bisa diisi. Produk punya nama, Harga Katalog, Satuan beserta tanda boleh pecahan, dan Kategori. Produk bisa diubah, dinonaktifkan, dan dicari; harga selalu tampil dalam format Rupiah tanpa desimal.

**Blocked by:** 01 (Kerangka aplikasi & seam test)

**Status:** done

- [x] Produk baru muncul di daftar Produk dengan harga berformat Rupiah tanpa desimal
- [x] Satuan bisa ditulis bebas dan ditandai boleh pecahan atau harus bulat
- [x] Kategori bisa dibuat dan dipakai untuk mengelompokkan Produk
- [x] Produk yang dinonaktifkan hilang dari daftar Produk aktif tapi tetap ditemukan di daftar seluruh Produk
- [x] Pencarian berdasarkan nama menyaring daftar Produk
- [x] Tidak ada tombol hapus permanen untuk Produk

## Comments

**2026-10-17 — selesai.** `flutter analyze` bersih, **29 test lulus** (18 lama + 7 `produk_test`, 3 `rupiah_test`, 1 `migrasi_test`).

Bentuknya:

- `Kategori` dan `Produk` masuk skema sebagai tabel sungguhan, `schemaVersion` naik 1 → 2 dengan satu langkah migrasi bernomor. `test/migrasi_test.dart` membuktikan janji di komentar migrasi: database versi 1 yang sudah berisi Data Toko naik ke versi 2 tanpa kehilangan apa pun, dan tabel baru langsung bisa dipakai.
- `ProdukStore` sengaja tidak punya `hapus`. Yang ada `setAktif`; ADR-0004 jadi sesuatu yang tidak bisa dilanggar karena tidak ada jalan memanggilnya.
- `formatRupiah`/`parseRupiah` di `lib/core/rupiah.dart` — satu tempat untuk aturan "titik ribuan, tanpa desimal", dipakai layar dan nanti Struk.
- Formulir Produk memakai `hargaKatalog` bertipe integer dan hanya menerima angka, jadi tidak ada jalan memasukkan "15.000,50" lalu berharap keajaiban.

Keputusan yang saya ambil:

- **Kategori boleh kosong.** User story 7 menyebut nama, Harga Katalog, Satuan, dan Stok awal — Kategori tidak ada di daftar itu. Jadi toko bisa mengisi katalog dulu, merapikan Kategori belakangan.
- **Penyaringan dikerjakan di layar, bukan di query.** Rancangan pertama saya memakai `StreamProvider.family` berkunci kata pencarian; itu membuat satu langganan database baru tiap ketikan dan yang lama tidak pernah dilepas. Sekarang satu langganan untuk seluruh katalog, disaring di memori. Katalog warung muat di memori; kalau suatu saat tidak, ini titik yang harus diubah.

Catatan yang belum ditutup:

- **Stok awal belum ada di formulir.** User story 7 menyebutnya, tapi Stok adalah modul tersendiri (tiket 05). Tanpa Stok, Produk baru masih belum bisa dijual.
- Kategori belum bisa diganti nama atau dihapus; baru bisa dibuat dan dipakai.
- `test/bantuan.dart` berisi `tutupAplikasi`: drift menjadwalkan pembersihan stream lewat timer nol detik saat `ProviderScope` di-dispose, dan flutter_test menganggap itu kebocoran. Pohon widget harus dilepas di dalam test, bukan setelahnya. Test apa pun yang membuka layar berkatalog perlu memanggilnya.
