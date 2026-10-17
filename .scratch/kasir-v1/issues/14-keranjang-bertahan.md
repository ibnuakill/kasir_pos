# 14: Keranjang bertahan

**What to build:** Keranjang bertahan. Isi Keranjang tersimpan, sehingga aplikasi yang ditutup atau dimatikan paksa membuka kembali Keranjang yang sama.

**Blocked by:** 07 (Layar kasir — katalog dan Keranjang)

**Status:** done

- [x] Menutup dan membuka kembali aplikasi memulihkan baris Keranjang beserta Kuantitas dan Diskon-nya
- [x] Keranjang yang dipulihkan menghitung Subtotal dan Total yang sama seperti sebelumnya
- [x] Hanya ada satu Keranjang aktif, dan menyimpan Transaksi mengosongkannya
- [x] Mengosongkan Keranjang secara sengaja tidak memulihkannya lagi saat aplikasi dibuka

## Comments

**2026-10-17** — 134 test lulus (8 baru di `test/keranjang_bertahan_test.dart`), `flutter analyze` bersih.

- Keranjang disimpan sebagai **satu potong JSON** di `app_settings` kunci `keranjang.aktif`, bukan tabel tersendiri: isinya state layar kasir yang selalu dibaca dan ditulis utuh, tidak pernah ditanyakan per baris, dan bentuknya bisa berubah tanpa migrasi skema. Skema tetap versi 6.
- Yang disimpan hanya **id Produk dan Kuantitas**. Nama dan Harga Katalog dibaca ulang dari katalog saat dipulihkan, jadi harga yang dipakai selalu harga yang berlaku (user story 36), bukan harga kemarin. Diskon ikut tersimpan sebagai jenis + nilai.
- Setiap perubahan langsung menulis lewat **satu antrean berurutan** (`_antrian`), supaya ketukan cepat berturut-turut tidak saling mendahului dan menyisakan isi Keranjang yang bukan yang terakhir terlihat di layar. `tungguTersimpan()` dipakai test supaya tidak menebak kapan tulisan terakhir mendarat.
- Keranjang kosong berarti **barisnya dihapus**, bukan disimpan kosong: itu yang membuat "menyimpan Transaksi" dan "mengosongkan Keranjang" sama-sama tidak dipulihkan lagi saat aplikasi dibuka.
- Pemulihan tidak menimpa isi yang sudah diketik: kalau kasir sudah mengetuk Produk selagi pembacaan berjalan, isi di layar yang menang.
- Simpanan yang rusak atau berbentuk lama dibaca sebagai "tidak ada Keranjang" — lebih baik mulai kosong daripada gagal membuka aplikasi. Baris yang Produknya sudah tidak ada dilewati, dan Diskon dibuang bila tidak ada baris tersisa.
- Tombol **Kosongkan Keranjang** (user story 42) sebelumnya belum ada di layar; sekarang ada di kepala panel Keranjang dengan satu konfirmasi, karena seluruh pesanan hilang sekaligus. Batal di konfirmasi tidak mengubah apa pun.
- `Notifier` tetap `IsiKeranjang` (bukan `AsyncNotifier`) supaya layar kasir tidak perlu menangani keadaan memuat; Keranjang kosong tampil sekejap lalu terisi.
