# Stok adalah hasil catatan pergerakan, bukan angka yang bisa ditimpa

Stok sebuah produk tidak disimpan sebagai satu angka bebas. Stok dihitung dari pergerakan yang tercatat: penjualan mengurangi, Tambah Stok menambah, Koreksi Stok menyesuaikan, dan transaksi batal mengembalikan.

Alternatif yang ditolak: satu kolom angka stok yang diedit langsung setiap kali barang masuk. Ditolak karena kalau angka stok ternyata meleset, tidak ada cara mengetahui kapan dan kenapa melesetnya — dan pemilik toko butuh tahu itu untuk memutuskan belanja.

Konsekuensi: setiap layar yang menampilkan stok harus menghitung atau membaca nilai turunan, dan setiap fitur baru yang menyentuh stok wajib menulis pergerakan, bukan menimpa angka.
