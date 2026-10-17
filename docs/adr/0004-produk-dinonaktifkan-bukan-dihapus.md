# Produk dinonaktifkan, tidak pernah dihapus

Produk yang sudah tidak dijual lagi hanya bisa dinonaktifkan: hilang dari katalog kasir, tapi barisnya tetap ada di database. Tidak ada tombol hapus permanen.

Alternatif yang ditolak: hapus permanen untuk produk yang belum pernah terjual. Ditolak karena menambah satu jalur kode yang berbeda perilaku (hapus vs nonaktif) tanpa manfaat nyata — produk yang salah input cukup dinonaktifkan, dan katalog tetap bersih karena katalog kasir hanya menampilkan produk aktif.

Konsekuensi: setiap daftar produk punya dua bentuk (semua produk untuk pengelolaan, hanya produk aktif untuk layar kasir), dan nama produk yang sudah nonaktif harus tetap bisa ditampilkan di riwayat transaksi lama.
