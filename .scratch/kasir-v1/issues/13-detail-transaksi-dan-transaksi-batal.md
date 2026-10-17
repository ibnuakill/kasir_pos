# 13: Detail Transaksi dan Transaksi Batal

**What to build:** Detail Transaksi dan pembatalan. Transaksi bisa dibatalkan dengan alasan wajib setelah PIN dimasukkan; Stok dikembalikan, Transaksi tetap tampil bertanda batal, dan Omzet tidak menghitungnya.

**Blocked by:** 12 (Laporan Harian), 03 (Pengaturan terkunci PIN)

**Status:** done

- [x] Detail Transaksi menampilkan isi Transaksi dan tombol batal
- [x] Membatalkan menuntut PIN dan alasan, dan keduanya wajib diisi
- [x] Stok setiap Produk di Transaksi kembali seperti sebelum terjual
- [x] Transaksi Batal tetap tampil di daftar dengan tanda batal dan alasannya
- [x] Omzet dan jumlah Transaksi tidak menghitung Transaksi Batal
- [x] Transaksi yang sudah batal tidak bisa dibatalkan lagi

## Comments

**2026-10-17** — 126 test lulus (9 baru di `test/detail_transaksi_test.dart`, 1 migrasi baru), `flutter analyze` bersih.

- Skema naik ke **versi 6**: `transaksi.batal`, `alasan_batal`, `waktu_batal`. Migrasi dijaga `if (from >= 4 && from < 6)` supaya database yang baru membuat tabel Transaksi di langkah `from < 4` tidak kena kolom ganda.
- `TransaksiStore.batalkan(id, alasan:, waktu:)` mengerjakan tiga hal dalam satu transaksi database: mencatat pergerakan `pembatalan` sebesar Kuantitas tiap baris (Stok kembali menurut ADR-0003, bukan ditimpa), menandai Transaksi batal, dan menyimpan alasannya.
- Pembatalan kedua **ditolak di lapisan data** (`TransaksiSudahBatalException`), bukan hanya dengan menyembunyikan tombol: membatalkan dua kali akan mengembalikan Stok dua kali. Layar juga tidak menawarkan tombolnya sama sekali untuk Transaksi yang sudah batal.
- Alasan kosong atau berisi spasi ditolak `ArgumentError` sebelum menyentuh database; tombol konfirmasi di dialog juga mati selama alasannya kosong.
- Urutannya **PIN dulu, baru alasan**: yang boleh membatalkan hanya pemilik toko, dan alasan yang sudah diketik tidak hilang kalau PIN salah (dialog PIN muncul lebih dulu).
- Layar baru `DetailTransaksiScreen` menampilkan kertas Struk yang sama dengan pratinjau setelah pembayaran, ditambah banner batal berisi alasan dan waktu batal. Tombol bagikan Struk ikut pindah ke sini, jadi Struk lama bisa dibagikan ulang (user story 58).
- Pembacaan Transaksi dan logika bagikan Struk diekstrak ke `IsiTransaksi`/`muatTransaksi` dan `bagikanStruk`, dipakai bersama oleh `StrukScreen` dan detail — tidak ada dua jalur yang bisa berbeda.
- Baris Transaksi Batal di Laporan dicoret, diberi "Batal · <alasan>" berwarna merah, dan tetap bisa dibuka.
- `LaporanHarian.omzet` dan `jumlahTransaksi` menyaring Transaksi Batal; daftarnya tetap memuat semuanya.
- Catatan lingkungan: `flutter build apk` dan tumpukan temp `flutter test` sempat menghabiskan ruang disk sampai build gagal (`errno = 112`). `build/` dan `%TEMP%\flutter_tools.*` sudah dibersihkan.
