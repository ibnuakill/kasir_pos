# 12: Laporan Harian

**What to build:** Laporan Harian berisi Omzet dan jumlah Transaksi untuk tanggal yang dipilih, beserta daftar Transaksi hari itu yang bisa dibuka satu per satu.

**Blocked by:** 09 (Pembayaran Tunai dan simpan Transaksi)

**Status:** done

- [x] Tab Laporan menampilkan Omzet dan jumlah Transaksi hari ini
- [x] Tanggal lain bisa dipilih dan kedua angka ikut berubah
- [x] Daftar Transaksi pada tanggal itu tampil dan bisa dibuka
- [x] Hari dihitung sebagai kalender perangkat dari 00:00 sampai 23:59 waktu lokal
- [x] Hari tanpa Transaksi menampilkan Omzet nol, bukan layar kosong atau pesan galat

## Comments

**2026-10-17** — 116 test lulus (7 baru di `test/laporan_test.dart`), `flutter analyze` bersih.

- `LaporanStore.watchHarian(tanggal)` membaca rentang `[awal hari, tengah malam berikutnya)` dan mengembalikan `LaporanHarian` yang menghitung Omzet **dari daftar yang sama** dengan yang ditampilkan. Dua angka di atas dan daftar di bawah tidak mungkin berbeda.
- Sumbernya stream drift, jadi Laporan ikut berubah sendiri begitu ada Transaksi baru — tidak perlu tarik-refresh.
- Tanggal tinggal di `tanggalLaporanProvider` (StateProvider, awal hari menurut `clockProvider`), bukan di dalam widget: pindah tab lalu kembali tetap di tanggal yang sama.
- Navigasi: panah kiri/kanan menggeser satu hari, ketuk tanggalnya membuka pemilih tanggal. Panah kanan mati saat sudah di hari ini — hari depan tidak mungkin punya Transaksi, dan tombol yang tidak berefek lebih membingungkan.
- Membuka satu Transaksi dari daftar menampilkan **Struk** yang sudah ada (tiket 11) lewat `StrukScreen.buka(context, id)`. Itu sudah menjawab "melihat apa saja yang terjual di dalamnya"; layar detail tersendiri dengan tombol Batal menyusul di tiket 13.
- Aplikasi sekarang berbahasa Indonesia sampai ke teks bawaan Flutter: `flutter_localizations` + `locale: id`. Akibatnya tooltip tombol kembali menjadi "Kembali", sehingga satu test yang memakai `tester.pageBack()` diganti menekan `BackButton` lewat jenisnya.
- Transaksi Batal belum ada di skema (kolomnya milik tiket 13), jadi Omzet sekarang menjumlahkan semua Transaksi hari itu. Saat tiket 13 menambah kolom batal, satu-satunya tempat yang perlu berubah adalah `LaporanHarian.omzet` dan `jumlahTransaksi`.
