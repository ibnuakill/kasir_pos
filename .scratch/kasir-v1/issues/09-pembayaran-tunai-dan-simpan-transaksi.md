# 09: Pembayaran Tunai dan simpan Transaksi

**What to build:** Pembayaran Tunai. Kasir memasukkan uang diterima, Kembalian dihitung, dan Transaksi tersimpan dengan nomor otomatis; Stok berkurang dan Keranjang kosong kembali.

**Blocked by:** 08 (Diskon dan Total)

**Status:** done

- [x] Uang diterima kurang dari Total menolak pembayaran dengan pesan yang jelas
- [x] Kembalian dihitung otomatis dari uang diterima dikurangi Total
- [x] Menyimpan Transaksi memberi nomor bersusun per hari yang tidak pernah kembar
- [x] Stok setiap Produk yang terjual berkurang sesuai Kuantitas-nya
- [x] Keranjang kosong kembali setelah Transaksi tersimpan
- [x] Transaksi menyimpan nama dan harga Produk saat terjual, sehingga riwayatnya tetap terbaca setelah Harga Katalog berubah

## Comments

**2026-10-17 — selesai (84 test lulus, analyze bersih).**

- `lib/core/nomor_transaksi.dart`: `TRX-<YYYYMMDD>-<NNN>`; tanggal diambil dari
  waktu Transaksi itu sendiri, urutan 3 digit. Kolom `nomor` tetap `unique()`
  sebagai jaring pengaman terakhir kalau ada dua penyimpanan bersamaan.
- Tabel `Transaksi` + `BarisTransaksi` (skema v4, migrasi `if (from < 4)`).
  Semua angka uang **dibekukan** di barisnya: harga satuan, subtotal, potongan,
  total, uang diterima, kembalian — struk lama tetap benar walau Harga Katalog
  berubah. Bentuk Diskon aslinya (`diskonJenis` + `diskonNilai`) juga disimpan
  supaya struk bisa menulis "Diskon 10%", bukan hanya nominal potongannya.
- `TransaksiStore.simpan` mengerjakan semua dalam satu `transaction`: cek Stok
  (dijumlahkan per Produk, bukan per baris) → tulis Transaksi → tulis baris →
  catat pergerakan Stok keluar jenis `penjualan`. Gagal di tengah = tidak ada
  yang tersimpan.
- Pembulatan harga baris dipindah ke `hitungSubtotalBaris` di `core/rupiah.dart`
  dan dipakai bersama Keranjang + Transaksi, supaya angka layar dan angka
  tersimpan tidak mungkin beda satu rupiah.
- UI: tombol **Bayar** di panel Keranjang → `PembayaranSheet` (Tunai). Kembalian
  dihitung sambil mengetik, tombol simpan mati selama uang kurang, pesan
  "Uang diterima kurang dari Total". Sukses → Keranjang dikosongkan + SnackBar
  berisi nomor Transaksi. QRIS = tiket 10, struk = tiket 11.
- Test: `test/transaksi_test.dart` (11) untuk nomor, pembekuan harga, Stok,
  uang kurang, dua baris Produk yang sama; 5 widget test pembayaran di
  `test/kasir_test.dart`; `test/migrasi_test.dart` sekarang juga menjual Produk
  lama setelah naik ke v4.
