# 10: QRIS

**What to build:** Metode Bayar QRIS. Gambar QR milik toko diunggah sekali di Pengaturan dan ditampilkan di layar pembayaran saat kasir memilih QRIS, sehingga pembeli bisa memindainya langsung dari layar.

**Blocked by:** 09 (Pembayaran Tunai dan simpan Transaksi), 03 (Pengaturan terkunci PIN)

**Status:** done

- [x] Gambar QR bisa diunggah dari galeri di Pengaturan dan tersimpan
- [x] Memilih QRIS saat membayar menampilkan gambar QR toko
- [x] Memilih QRIS saat gambar QR belum diatur memberi pesan bahwa gambar belum ada
- [x] Transaksi QRIS tersimpan dengan Metode Bayar QRIS dan tanpa Kembalian
- [x] Transaksi Tunai tidak menampilkan gambar QR

## Comments

**2026-10-17** — Selesai. 94 test lulus (10 baru di `test/qris_test.dart`), `flutter analyze` bersih.

- Izin galeri/kamera dibungkus `PemilihGambar` (`lib/core/pemilih_gambar.dart`) supaya test tidak butuh kamera dan bisa dipakai ulang oleh tiket 06 (Foto Produk). `KasirApp` sekarang menerima `overrides` agar test bisa menggantinya.
- Gambar disimpan sebagai **berkas** di `<appSupport>/gambar` lewat `GambarStore`; database hanya menyimpan path (`qris.gambar`). Mengganti gambar membuang berkas lama bernama sama supaya tidak menumpuk, dan Hapus ikut menghapus berkasnya.
- `QrisStore.baca()` mengembalikan null kalau setting kosong; berkas yang hilang ditangani `errorBuilder` gambar, bukan kotak rusak.
- QRIS tidak punya uang diterima maupun Kembalian: `_simpan` mengirim `uangDiterima: null` untuk QRIS (story 43), dan kolom itu tetap kosong di Transaksi.
- Di dalam widget test, I/O berkas berjalan di zona waktu palsu dan tidak pernah selesai — karena itu `GambarStore` diganti tiruan di widget test, sementara penyalinan berkas sungguhan diuji di test biasa.
- iOS: `NSCameraUsageDescription` + `NSPhotoLibraryUsageDescription` ditambahkan ke `Info.plist`. Android tidak butuh izin tambahan (image_picker memakai photo picker sistem).
