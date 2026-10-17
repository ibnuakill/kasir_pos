# Kasir

Aplikasi kasir (POS) untuk satu toko, dijalankan dari satu device pada satu waktu, dengan tampilan yang menyesuaikan ukuran layar HP maupun tablet.

## Language

**Keranjang**:
Kumpulan baris yang sedang disusun kasir dan belum dibayar. Disimpan, sehingga utuh lagi saat aplikasi dibuka kembali.

**Transaksi**:
Satu kejadian jual beli yang sudah dibayar dan menghasilkan struk.
_Avoid_: Order, penjualan, invoice, nota

**Transaksi Batal**:
Transaksi yang sudah tersimpan lalu dibatalkan; alasan pembatalan wajib dicatat, stok produknya dikembalikan, dan transaksi itu tetap tampil di daftar laporan dengan tanda batal tapi tidak ikut dihitung sebagai omzet.
_Avoid_: Void, refund, retur, hapus transaksi

**Produk**:
Barang yang dijual toko, punya harga jual, satuan, stok, kategori, dan foto.
_Avoid_: Item, barang, SKU

**Kategori**:
Pengelompokan produk untuk menyusun katalog di layar kasir.
_Avoid_: Grup, tag, jenis

**Foto Produk**:
Gambar yang mewakili sebuah produk di katalog.
_Avoid_: Thumbnail, gambar, image

**Harga Katalog**:
Harga jual produk yang tersimpan di katalog dan selalu dipakai apa adanya di baris transaksi. Tidak bisa diubah per baris saat jualan; potongan hanya lewat Diskon.
_Avoid_: Harga manual, harga nego, harga khusus

**Satuan**:
Unit yang dipakai untuk menjual sebuah produk, ditulis bebas mengikuti kebiasaan toko (pcs, kg, liter, bungkus). Satu produk hanya punya satu satuan, dan tiap satuan ditandai boleh pecahan (kg, liter) atau harus bulat (pcs, bungkus).
_Avoid_: UoM, unit

**Kuantitas**:
Jumlah produk pada satu baris transaksi; boleh berupa pecahan (contoh: 2.5 kg).
_Avoid_: Qty, quantity, jumlah

**Stok**:
Jumlah produk yang tersedia untuk dijual. Berkurang setiap transaksi tercatat, bertambah lewat Tambah Stok dan Koreksi Stok, dan kembali saat transaksi batal. Tidak pernah bernilai negatif.
_Avoid_: Inventori, persediaan, stock

**Tambah Stok**:
Catatan barang masuk untuk sebuah produk: jumlahnya dan tanggalnya, dicatat sebagai pergerakan stok.
_Avoid_: Restock, pembelian, barang masuk

**Koreksi Stok**:
Penyesuaian angka stok saat hitungan fisik di toko berbeda dengan catatan.
_Avoid_: Opname, adjustment, penyesuaian

**Produk Nonaktif**:
Produk yang disembunyikan dari katalog kasir tapi riwayat transaksinya tetap utuh.
_Avoid_: Produk dihapus, arsip

**Subtotal**:
Jumlah harga semua baris transaksi sebelum diskon.
_Avoid_: Total sementara

**Diskon**:
Potongan harga pada level transaksi — bukan per produk — berupa nominal rupiah atau persen dari subtotal.
_Avoid_: Promo, potongan, rabat

**Total**:
Jumlah yang harus dibayar pembeli: subtotal dikurangi diskon.
_Avoid_: Grand total, tagihan

**Metode Bayar**:
Cara pembeli melunasi transaksi. Untuk versi ini hanya **Tunai** dan **QRIS**.
_Avoid_: Payment method, tipe pembayaran

**QRIS**:
Metode bayar non-tunai lewat pemindaian QR. Aplikasi menyimpan satu gambar QR statis milik toko dan menampilkannya saat kasir memilih QRIS.
_Avoid_: QR, scan, e-wallet

**Kembalian**:
Selisih uang tunai yang diserahkan pembeli dengan total transaksi.
_Avoid_: Change, uang kembali

**Data Toko**:
Nama dan alamat toko yang dicetak di bagian atas struk.
_Avoid_: Profil, identitas toko

**Struk**:
Bukti transaksi yang diserahkan ke pembeli dalam bentuk gambar.
_Avoid_: Nota, receipt, invoice, bill

**Omzet**:
Jumlah nilai transaksi yang tidak batal dalam satu hari.
_Avoid_: Pendapatan, revenue, penjualan

**Laporan Harian**:
Rekap satu hari kalender device untuk tanggal yang dipilih; isinya omzet, jumlah transaksi, dan daftar transaksi hari itu.
_Avoid_: Report, rekap, closing

**Backup**:
Satu file ZIP berisi data aplikasi dalam bentuk JSON beserta foto produk, dan bisa di-import kembali untuk memulihkan keadaan.
_Avoid_: Export, dump, cadangan

**PIN**:
Kode 4–6 digit yang diminta hanya saat masuk ke Pengaturan dan saat membatalkan transaksi. Bukan login; tidak mengidentifikasi siapa yang memakainya.
_Avoid_: Password, login, sandi
