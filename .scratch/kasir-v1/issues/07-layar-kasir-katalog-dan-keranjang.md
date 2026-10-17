# 07: Layar kasir — katalog dan Keranjang

**What to build:** Layar kasir tempat penjualan disusun. Katalog Produk aktif bisa difilter Kategori dan dicari, ditekan untuk masuk Keranjang; Kuantitas bisa diubah atau barisnya dihapus; Subtotal mengikuti isi Keranjang. Penjualan diblokir saat Stok nol. Di layar lebar katalog dan Keranjang berdampingan; di layar sempit Keranjang jadi panel bawah yang bisa dibuka-tutup dengan Total tetap terlihat.

**Blocked by:** 05 (Stok sebagai catatan pergerakan)

**Status:** done

- [x] Menekan Produk memasukkan satu baris ke Keranjang; menekannya lagi menambah Kuantitas baris itu
- [x] Kuantitas bisa diubah langsung dan baris bisa dihapus dari Keranjang
- [x] Kuantitas pecahan diterima untuk Satuan boleh pecahan dan ditolak untuk Satuan bulat
- [x] Subtotal mengikuti isi Keranjang tanpa menekan tombol hitung
- [x] Produk dengan Stok nol tidak bisa masuk Keranjang, dengan pesan yang menjelaskan Stok harus diisi dulu
- [x] Pada lebar tablet katalog dan Keranjang tampil berdampingan; pada lebar HP satu tampil penuh dengan panel Keranjang yang bisa dibuka
- [x] Harga baris tidak bisa diubah dari layar kasir

## Comments

**2026-10-17**

- Keranjang masih **di memori** (`Notifier<List<BarisKeranjang>>`). Bertahan saat aplikasi ditutup itu tiket 14, dan "Kosongkan Keranjang" juga di sana.
- Harga baris adalah **salinan Harga Katalog saat Produk dimasukkan**, bukan rujukan ke tabel Produk. Jadi kalau Harga Katalog diubah belakangan, baris yang sudah ada tidak ikut berubah — sesuai story 36 (harga tidak bisa diubah dari layar kasir).
- Harga baris dibulatkan ke rupiah terdekat: `harga × kuantitasMili` dibagi `skalaKuantitas`, karena uang tidak punya pecahan di aplikasi ini.
- Batas Stok **tidak** ditegakkan di Keranjang; yang diblokir hanya Stok nol. Aturan "Stok kurang dari Kuantitas memblokir penjualan" (ADR-0002) ditegakkan saat bayar di tiket 08/09, supaya kasir tetap bisa menyusun Keranjang lalu membetulkan Kuantitas.
- Satu breakpoint `KasirScreen.lebarTablet = 600`. Di bawahnya Keranjang jadi panel bawah (bottom sheet) dengan bar "N item · Total Rp…" yang selalu terlihat; selama Diskon belum ada (tiket 08), Total = Subtotal.
- Pencarian dan saringan Kategori dilakukan di memori dari satu `daftarProdukProvider`, sama seperti tiket 04 — bukan provider per kata kunci.
- Test: `test/kasir_test.dart` (10 test) menutup seluruh checklist, termasuk dua uji tata letak (lebar 800 vs 400) dan uji "hanya satu kolom ketik per baris".
- Efek samping: layar Kasir kini berlangganan stream database, jadi **semua** test yang memompa `KasirApp` wajib `tutupAplikasi(tester)`; kalau tidak, drift meninggalkan timer nol detik dan test gagal "A Timer is still pending".
