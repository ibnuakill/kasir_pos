# 01: Kerangka aplikasi & seam test

**What to build:** Aplikasi berjalan sebagai kasir kosong dengan empat tab — Kasir, Produk, Laporan, Pengaturan — dan seluruh aplikasi bisa dijalankan di dalam test terhadap database in-memory dengan sumber waktu tetap. Aplikasi demo counter bawaan Flutter diganti seluruhnya.

**Blocked by:** None (can start immediately)

**Status:** done

- [x] Membuka aplikasi menampilkan empat tab dan tidak ada sisa aplikasi counter
- [x] Seluruh aplikasi bisa dijalankan di test dengan database in-memory dan sumber waktu tetap, tanpa menyentuh penyimpanan perangkat
- [x] Tema mengikuti mode gelap atau terang perangkat
- [x] Widget test bawaan diganti test yang membuktikan seam itu benar-benar bekerja
- [x] Skema database punya nomor versi dan jalur migrasi sejak versi pertama

## Comments

**2026-10-17 — selesai.** `flutter analyze` bersih, 4 widget test lulus di `test/app_shell_test.dart`.

Bentuk yang jadi:

- `KasirApp` menerima `database` dan `clock` sebagai parameter, lalu mengisi `databaseProvider` dan `clockProvider` lewat `ProviderScope`. Tidak ada bagian aplikasi yang membuka database sendiri.
- `AppDatabase` punya `AppDatabase.inMemory()` untuk test dan `openAppDatabase()` untuk perangkat. `schemaVersion = 1` dengan `MigrationStrategy` yang sudah menyediakan `onUpgrade` kosong sebagai tempat langkah migrasi berikutnya.
- Satu tabel `app_settings` (kunci–nilai) sebagai isi skema versi 1. Data Toko, PIN, dan rujukan gambar QR akan memakainya di tiket 02, 03, dan 10.

Catatan review yang **belum** ditutup:

- Seam baru terpasang, belum terbukti. Belum ada satu pun bagian aplikasi yang membaca `clockProvider` atau `databaseProvider`, jadi test saat ini akan tetap lulus kalau override-nya dihapus. Pembuktian sebenarnya baru terjadi di tiket 02, ketika wizard menulis Data Toko lewat database dan membaca waktu dari clock.
- Kunci pengaturan masih berupa `String` bebas (`setSetting('toko_nama', ...)`). Salah tulis kunci baru ketahuan saat runtime. Perlu dijadikan satu daftar kunci bernama saat tiket 02 mulai memakainya.
