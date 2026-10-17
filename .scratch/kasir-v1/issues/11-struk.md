# 11: Struk

**What to build:** Struk untuk pembeli. Setelah Transaksi tersimpan, pratinjau Struk muncul berisi Data Toko, nomor dan waktu, rincian item, Subtotal, Diskon, Total, Metode Bayar, dan Kembalian. Struk bisa dibagikan sebagai gambar dan dibuka lagi nanti.

**Blocked by:** 09 (Pembayaran Tunai dan simpan Transaksi)

**Status:** done

- [x] Pratinjau Struk muncul setelah Transaksi tersimpan
- [x] Struk memuat nama dan alamat toko, nomor Transaksi, tanggal dan jam, rincian item beserta Kuantitas dan Satuan, Subtotal, Diskon, Total, Metode Bayar, dan Kembalian
- [x] Struk bisa dibagikan sebagai gambar lewat lembar berbagi sistem
- [x] Struk Transaksi QRIS tidak menampilkan baris Kembalian yang kosong dan membingungkan
- [ ] Struk bisa dibagikan ulang dari detail Transaksi — menunggu tiket 13 (layar detailnya belum ada); `StrukScreen.buka(context, id)` sudah siap dipanggil dari sana

## Comments

**2026-10-17** — Selesai kecuali satu butir yang memang milik tiket 13. 109 test lulus (7 baru di `test/struk_test.dart`), `flutter analyze` bersih.

- Struk tampil **menggantikan** SnackBar "Transaksi tersimpan": nomor Transaksi di atas kertas sudah jadi bukti, dan pesan singkat yang menutupi tombol Bayar justru mengganggu. Tiga test tiket 09/10 ikut disesuaikan (tutup Struk dulu sebelum memeriksa layar kasir).
- `StrukScreen` menerima **id Transaksi**, bukan objek jadi, lalu membaca sendiri dari database. Itu yang membuat detail Transaksi (tiket 13) bisa membagikan ulang Struk lama tanpa jalur kode kedua.
- Gambar dihasilkan dari `RepaintBoundary` di sekitar kertas struk (`gambarStrukPng`, skala 3) lalu dikirim ke lembar berbagi lewat `Pembagi` — antarmuka baru di `core/pembagi.dart`, diganti tiruan di test. Berkas dikirim dari data (`XFile.fromData`), jadi tidak ada berkas sementara yang perlu dibersihkan.
- Warna Struk dikunci terang: gambar struk tidak boleh ikut jadi gelap saat HP memakai mode gelap.
- Baris "Uang Diterima" dan "Kembalian" hanya ada untuk Tunai; Transaksi QRIS tidak menampilkan keduanya sama sekali, bukan menampilkan nol.
- `share_plus` 13.3.1 minta Android Gradle Plugin ≥ 8.12.1, jadi `android/settings.gradle.kts` naik dari 8.11.1 → 8.12.1 (Gradle 8.14 dan iOS 13.0 sudah memenuhi).
- Catatan test: render PNG butuh event loop sungguhan, jadi tombol bagikan ditekan di dalam `tester.runAsync`; di zona waktu palsu `toImage` tidak pernah selesai.
