# Spec: Kasir v1

Status: ready-for-agent

## Problem Statement

Pemilik toko kecil mencatat penjualan di kertas atau mengingat-ingat. Akibatnya: dia tidak tahu berapa omzet hari ini tanpa menghitung ulang, angka stok di kepalanya tidak pernah cocok dengan barang di rak, dan pembeli tidak punya bukti bayar kalau uangnya dipersoalkan. Aplikasi kasir yang ada biasanya menuntut internet, langganan bulanan, atau perangkat khusus — semuanya berlebihan untuk satu meja kasir di toko kelontong.

## Solution

Satu aplikasi yang berjalan penuh di satu HP atau tablet tanpa internet: katalog Produk dengan Foto Produk dan Kategori, Keranjang yang mencatat penjualan, pembayaran Tunai atau QRIS, Struk berupa gambar yang bisa dibagikan, dan Laporan Harian berisi Omzet serta daftar Transaksi. Stok bergerak lewat catatan Tambah Stok, Koreksi Stok, dan penjualan — bukan angka yang diketik ulang. Semua data bisa diekspor sebagai Backup ZIP karena tidak ada server yang menyimpannya.

## User Stories

**Menyiapkan toko**

1. As a pemilik toko, I want membuka aplikasi tanpa internet sama sekali, so that saya bisa mulai jualan walau sinyal mati.
2. As a pemilik toko, I want dipandu wizard singkat saat pertama membuka aplikasi, so that saya tidak perlu mengatur apa pun sebelum bisa menjual.
3. As a pemilik toko, I want mengisi nama dan alamat toko di wizard, so that Struk langsung memakai identitas toko tanpa saya ketik ulang tiap transaksi.
4. As a pemilik toko, I want menambahkan Produk pertama langsung dari wizard, so that saya bisa mencoba satu Transaksi penuh sebelum mengetik seluruh katalog.
5. As a pemilik toko, I want menentukan PIN saat wizard, so that Pengaturan dan pembatalan Transaksi tidak bisa disentuh orang lain yang memegang HP.
6. As a pemilik toko, I want mengubah Data Toko kapan saja, so that alamat di Struk ikut benar kalau toko pindah.

**Mengelola katalog**

7. As a pemilik toko, I want menambah Produk dengan nama, Harga Katalog, Satuan, dan Stok awal, so that Produk itu langsung bisa dijual.
8. As a pemilik toko, I want menulis Satuan bebas (pcs, kg, liter, bungkus), so that satuannya cocok dengan cara saya benar-benar menjual.
9. As a pemilik toko, I want menandai Satuan boleh pecahan atau harus bulat, so that beras bisa dijual 2.5 kg sementara sabun tidak bisa dijual 1.5 pcs.
10. As a pemilik toko, I want mengisi Stok awal lewat form Tambah Stok, so that Stok pertama punya tanggal dan alasan, bukan angka yang muncul entah dari mana.
11. As a pemilik toko, I want membuat dan menamai Kategori, so that katalog di layar kasir terbagi dan gampang dicari saat toko ramai.
12. As a pemilik toko, I want menempelkan Foto Produk pada sebuah Produk, so that kasir tidak salah ambil barang yang namanya mirip.
13. As a pemilik toko, I want mengambil Foto Produk dari kamera atau memilihnya dari galeri, so that saya tidak perlu memindahkan foto ke komputer dulu.
14. As a pemilik toko, I want mengubah nama, Harga Katalog, Satuan, Kategori, dan Foto Produk, so that katalog tetap mengikuti keadaan toko.
15. As a pemilik toko, I want menonaktifkan Produk yang sudah tidak dijual, so that katalog kasir tetap bersih tanpa kehilangan riwayat.
16. As a pemilik toko, I want melihat daftar seluruh Produk termasuk yang nonaktif, so that saya bisa mengaktifkannya lagi kalau barangnya masuk lagi.
17. As a pemilik toko, I want Produk nonaktif tetap tampil dengan namanya di Transaksi lama, so that riwayat penjualan tetap terbaca bertahun-tahun kemudian.
18. As a pemilik toko, I want mencari Produk berdasarkan nama di layar pengelolaan, so that saya tidak menggulir ratusan baris untuk mengubah satu harga.

**Mengurus stok**

19. As a pemilik toko, I want mencatat barang masuk lewat form Tambah Stok berisi jumlah dan tanggal, so that setiap penambahan Stok punya jejak.
20. As a pemilik toko, I want melihat riwayat pergerakan Stok sebuah Produk, so that saya tahu kenapa Stok-nya sekarang segini.
21. As a pemilik toko, I want melakukan Koreksi Stok saat hitungan fisik berbeda dengan catatan, so that catatan menyesuaikan kenyataan tanpa menghapus jejak sebelumnya.
22. As a pemilik toko, I want melihat Stok setiap Produk di daftar Produk, so that saya tahu apa yang perlu dibeli tanpa membuka satu-satu.
23. As a pemilik toko, I want Stok tidak pernah bernilai negatif, so that angka Stok bisa saya percaya saat memutuskan belanja.

**Menjual**

24. As a kasir, I want melihat katalog Produk aktif dalam bentuk grid berisi Foto Produk, nama, dan Harga Katalog, so that saya mengenali barang dengan cepat.
25. As a kasir, I want memfilter katalog per Kategori, so that saya tidak menggulir seluruh toko untuk satu barang.
26. As a kasir, I want mencari Produk berdasarkan nama di layar kasir, so that saya bisa melayani pembeli yang menyebut merek tertentu.
27. As a kasir, I want menekan sebuah Produk untuk memasukkannya ke Keranjang, so that satu ketukan sudah cukup saat antrean panjang.
28. As a kasir, I want menekan Produk yang sudah ada di Keranjang untuk menambah Kuantitas-nya, so that menjual tiga botol tidak butuh tiga layar.
29. As a kasir, I want mengubah Kuantitas satu baris Keranjang secara langsung, so that saya bisa membetulkan salah ketuk tanpa menghapus barisnya.
30. As a kasir, I want mengisi Kuantitas pecahan untuk Produk bersatuan pecahan, so that saya bisa menjual 0.75 liter minyak.
31. As a kasir, I want Kuantitas pecahan ditolak untuk Produk bersatuan bulat, so that saya tidak pernah mencatat 1.5 pcs.
32. As a kasir, I want menghapus satu baris dari Keranjang, so that pembeli yang batal mengambil barang tidak mengotori Transaksi.
33. As a kasir, I want melihat Subtotal, Diskon, dan Total yang berubah seketika, so that saya bisa menyebut angka ke pembeli tanpa menghitung sendiri.
34. As a kasir, I want Transaksi ditolak saat Stok sebuah Produk nol, so that saya tidak menjual barang yang sistemnya bilang tidak ada.
35. As a kasir, I want pesan yang jelas saat penjualan diblokir karena Stok nol, so that saya tahu harus mengisi Stok dulu, bukan mengira aplikasinya rusak.
36. As a kasir, I want Harga Katalog dipakai apa adanya dan tidak bisa saya ubah per baris, so that harga di katalog tetap bisa dipercaya pemilik toko.
37. As a kasir, I want memberi Diskon berupa nominal rupiah, so that saya bisa membulatkan harga untuk pelanggan langganan.
38. As a kasir, I want memberi Diskon berupa persen, so that potongan besar tidak perlu saya hitung manual.
39. As a kasir, I want Diskon dibatasi maksimal sebesar Subtotal, so that Total tidak pernah menjadi angka minus.
40. As a kasir, I want Keranjang tersimpan saat aplikasi ditutup atau dimatikan paksa, so that pekerjaan menyusun pesanan tidak hilang.
41. As a kasir, I want Keranjang pulih utuh saat aplikasi dibuka kembali, so that saya bisa melanjutkan pesanan yang tertunda.
42. As a kasir, I want mengosongkan Keranjang dengan satu aksi, so that saya bisa membatalkan pesanan yang salah orang.

**Membayar dan menutup transaksi**

43. As a kasir, I want memilih Metode Bayar Tunai atau QRIS, so that Transaksi mencatat cara pembeli benar-benar membayar.
44. As a kasir, I want memasukkan uang tunai yang diterima dan melihat Kembalian dihitung otomatis, so that saya tidak salah mengembalikan uang.
45. As a kasir, I want pembayaran Tunai ditolak kalau uang diterima kurang dari Total, so that Transaksi tidak tercatat lunas padahal belum.
46. As a kasir, I want melihat gambar QRIS milik toko saat memilih QRIS, so that pembeli bisa langsung memindai dari layar.
47. As a kasir, I want menyelesaikan pembayaran dengan satu tombol, so that Transaksi tersimpan tanpa langkah tambahan.
48. As a kasir, I want nomor Transaksi dibuat otomatis dengan tanggal dan urutan harian, so that setiap Struk bisa dirujuk tanpa saya mengarang nomor.
49. As a kasir, I want Stok berkurang otomatis begitu Transaksi tersimpan, so that catatan Stok tidak perlu saya perbarui manual.
50. As a kasir, I want Keranjang kosong kembali setelah Transaksi tersimpan, so that pembeli berikutnya mulai dari nol.

**Struk**

51. As a kasir, I want melihat pratinjau Struk begitu Transaksi tersimpan, so that saya bisa memastikan isinya benar sebelum diserahkan.
52. As a pemilik toko, I want Struk memuat nama dan alamat toko, so that pembeli tahu dari mana Struk itu berasal.
53. As a pembeli, I want Struk memuat nomor Transaksi serta tanggal dan jam, so that saya bisa merujuknya kalau ada keberatan.
54. As a pembeli, I want Struk memuat rincian item berisi nama, Kuantitas, Satuan, dan harga, so that saya bisa mencocokkan belanjaan.
55. As a pembeli, I want Struk memuat Subtotal, Diskon, dan Total, so that saya tahu angka akhirnya berasal dari mana.
56. As a pembeli, I want Struk memuat Metode Bayar dan Kembalian, so that saya punya bukti cara dan sisa uang saya.
57. As a kasir, I want membagikan Struk sebagai gambar lewat aplikasi lain di HP, so that pembeli bisa menerimanya lewat pesan tanpa saya menyalin apa pun.
58. As a kasir, I want Struk tetap bisa dibagikan lagi dari detail Transaksi, so that pembeli yang meminta ulang tidak perlu saya buatkan Transaksi baru.

**Laporan dan pembatalan**

59. As a pemilik toko, I want melihat Omzet dan jumlah Transaksi hari ini di tab Laporan, so that saya tahu hasil hari itu sebelum menutup toko.
60. As a pemilik toko, I want memilih tanggal lain di tab Laporan, so that saya bisa memeriksa hari kemarin tanpa menunggu laporan bulanan.
61. As a pemilik toko, I want melihat daftar Transaksi pada tanggal yang dipilih, so that saya bisa menelusuri satu per satu.
62. As a pemilik toko, I want membuka detail sebuah Transaksi dari daftar, so that saya bisa melihat apa saja yang terjual di dalamnya.
63. As a pemilik toko, I want membatalkan Transaksi yang sudah tersimpan dengan alasan yang wajib diisi, so that kesalahan input tidak membuat Omzet selamanya salah.
64. As a pemilik toko, I want Stok dikembalikan saat Transaksi dibatalkan, so that barang yang batal terjual kembali tersedia.
65. As a pemilik toko, I want Transaksi Batal tetap tampil di daftar dengan tanda batal dan alasannya, so that jejak kesalahannya tidak hilang.
66. As a pemilik toko, I want Omzet tidak menghitung Transaksi Batal, so that angka Omzet berarti uang yang benar-benar masuk.
67. As a pemilik toko, I want jumlah Transaksi di laporan juga tidak menghitung Transaksi Batal, so that dua angka di laporan saling konsisten.
68. As a pemilik toko, I want PIN diminta sebelum membatalkan Transaksi, so that kasir tidak bisa membatalkan tanpa sepengetahuan saya.

**Melindungi data**

69. As a pemilik toko, I want PIN diminta sebelum masuk Pengaturan, so that harga dan Data Toko tidak bisa diubah orang lain.
70. As a pemilik toko, I want mengganti PIN kapan saja, so that PIN yang bocor bisa saya ganti.
71. As a pemilik toko, I want mengekspor seluruh data ke satu file Backup, so that data selamat kalau HP hilang atau rusak.
72. As a pemilik toko, I want Backup berisi Produk, Kategori, Foto Produk, riwayat Stok, Transaksi, dan Data Toko, so that pemulihan mengembalikan toko ke keadaan sebelumnya, bukan cuma sebagian.
73. As a pemilik toko, I want membagikan file Backup lewat aplikasi lain di HP, so that saya bisa menyimpannya ke drive atau mengirimnya ke diri sendiri.
74. As a pemilik toko, I want mengimpor file Backup, so that saya bisa memulihkan data di HP baru.
75. As a pemilik toko, I want peringatan yang jelas sebelum impor menimpa data yang ada, so that saya tidak menghapus toko yang sedang berjalan karena salah pencet.
76. As a pemilik toko, I want melihat tanggal Backup terakhir yang saya buat, so that saya ingat kapan terakhir mengamankan data.
77. As a pemilik toko, I want menyimpan gambar QRIS milik toko di Pengaturan, so that pembeli bisa memindainya tanpa saya mencari gambar tiap kali.

**Memakai di layar apa pun**

78. As a pemilik toko, I want berpindah antara Kasir, Produk, Laporan, dan Pengaturan lewat empat tab di bawah, so that semua bagian aplikasi terjangkau satu ketukan.
79. As a pemilik toko, I want layar kasir di tablet menampilkan katalog di kiri dan Keranjang di kanan sekaligus, so that layar lebar benar-benar berguna.
80. As a kasir, I want layar kasir di HP menampilkan Keranjang sebagai panel bawah yang bisa dibuka-tutup, so that katalog tetap lega di layar sempit.
81. As a kasir, I want jumlah item dan Total tetap terlihat saat panel Keranjang tertutup, so that saya tidak kehilangan konteks.
82. As a pemilik toko, I want seluruh angka uang tampil dalam format Rupiah tanpa desimal, so that tidak ada angka sen yang membingungkan.
83. As a pemilik toko, I want seluruh antarmuka berbahasa Indonesia, so that saya tidak perlu menerjemahkan istilah asing.
84. As a pemilik toko, I want tampilan mengikuti mode gelap atau terang perangkat, so that aplikasi tidak menyilaukan saat toko diremangkan.

## Implementation Decisions

**Modul**

- **Katalog** — Produk (nama, Harga Katalog, Satuan beserta tanda boleh pecahan, Kategori, Foto Produk, status aktif), Kategori, pencarian, dan penyuntingan.
- **Stok** — pergerakan Stok (penjualan, Tambah Stok, Koreksi Stok, pengembalian akibat Transaksi Batal) dan nilai Stok turunan.
- **Kasir** — Keranjang sebagai draft tersimpan, penambahan baris, pengubahan Kuantitas, perhitungan Subtotal/Diskon/Total.
- **Pembayaran** — pemilihan Metode Bayar, uang diterima, Kembalian, validasi.
- **Struk** — penyusunan isi Struk dan render menjadi gambar.
- **Laporan** — Omzet, jumlah Transaksi, daftar Transaksi per tanggal, detail, pembatalan.
- **Pengaturan** — Data Toko, gambar QRIS, PIN, Backup ekspor/impor.
- **Gerbang PIN** — pemeriksaan PIN tunggal yang dipakai ulang oleh Pengaturan dan pembatalan Transaksi.

**Bentuk data**

- Uang disimpan sebagai bilangan bulat rupiah. Tidak ada tipe desimal untuk uang di mana pun.
- Kuantitas disimpan sebagai bilangan bulat berskala seribu (tiga angka desimal), supaya 0.75 liter tidak kehilangan presisi seperti pada floating point.
- Stok **tidak** disimpan sebagai kolom yang bisa ditimpa. Stok adalah penjumlahan pergerakan (ADR-0003); kalau di-cache, nilainya wajib diturunkan dan bisa dibangun ulang dari pergerakan.
- Produk tidak pernah dihapus, hanya punya status aktif (ADR-0004). Baris Transaksi menyimpan nama dan harga Produk saat terjual supaya Struk lama tetap terbaca walau Produknya kemudian dinonaktifkan atau harganya berubah.
- Transaksi menyimpan status batal, alasan batal, dan waktu batal. Pembatalan menulis pergerakan Stok pengembalian.
- Keranjang disimpan sebagai draft di database, bukan hanya di memori. Hanya ada satu draft aktif.
- Nomor Transaksi berbentuk `TRX-<YYYYMMDD>-<NNN>`, urut per hari, dialokasikan di dalam satu transaksi database agar tidak pernah kembar.
- Foto Produk dan gambar QRIS disimpan sebagai berkas di penyimpanan aplikasi, dengan rujukan di database; keduanya ikut ke dalam Backup.

**Aturan yang mengikat**

- Diskon hanya di level Transaksi, berupa nominal atau persen dari Subtotal. Total = Subtotal − Diskon, dan hasilnya dijepit tidak kurang dari nol.
- Diskon persen dibulatkan ke rupiah terdekat sebelum dikurangkan.
- Harga baris tidak bisa diubah saat menjual (Harga Katalog dipakai apa adanya).
- Penjualan diblokir bila Stok kurang dari Kuantitas yang diminta (ADR-0002).
- Kuantitas pecahan hanya diterima untuk Satuan bertanda boleh pecahan; selain itu Kuantitas harus bilangan bulat.
- Satu Produk punya tepat satu Satuan, tanpa konversi antar satuan (ADR-0005).
- Transaksi Batal tidak masuk Omzet maupun jumlah Transaksi, tetapi tetap tampil di daftar.
- "Hari" adalah kalender perangkat, 00:00–23:59 waktu lokal.
- PIN disimpan sebagai hash, tidak pernah sebagai teks biasa, dan tidak mengidentifikasi siapa pemakainya (ADR-0006).

**Bentuk antarmuka**

- Empat tab bawah: Kasir, Produk, Laporan, Pengaturan.
- Layar kasir responsif pada satu breakpoint lebar: di bawahnya katalog penuh dengan panel Keranjang yang bisa dibuka-tutup, di atasnya katalog dan Keranjang berdampingan.
- Struk dirender menjadi gambar lalu diserahkan ke lembar berbagi sistem. Tidak ada printer dan tidak ada format teks.
- Backup berupa satu berkas ZIP berisi data JSON dan berkas gambar; ekspor lewat lembar berbagi, impor lewat pemilih berkas, dan impor menimpa seluruh data setelah konfirmasi.

**Teknis**

- Flutter, state management Riverpod, database lokal drift di atas SQLite.
- Root widget aplikasi menerima database dan sumber waktu sebagai dependensi, sehingga seluruh aplikasi bisa dijalankan terhadap database in-memory dan waktu tetap di dalam test.
- Skema drift dibuat dengan migrasi bernomor sejak versi pertama, supaya perubahan bentuk data berikutnya tidak menghapus data toko.
- Aplikasi tidak memuat SDK pihak ketiga untuk pembayaran, iklan, atau analitik.

## Testing Decisions

**Apa yang membuat test bagus di sini**

Test hanya menyentuh perilaku yang bisa dilihat pengguna: menekan tombol, membaca teks di layar, melihat daftar berubah. Test tidak boleh memeriksa isi tabel, memanggil repository langsung, atau mengunci nama widget internal — semua itu berubah bebas selama perilaku di layar tetap.

**Seam**

Satu seam: root widget aplikasi, dijalankan dengan database in-memory dan sumber waktu tetap. Setiap test membangun aplikasinya sendiri dari nol, menyiapkan keadaan lewat layar yang sama yang dipakai kasir (bukan lewat penyuntikan data langsung), lalu menegaskan hasilnya di layar.

**Modul yang diuji**

Seluruh modul diuji lewat seam itu — Katalog, Stok, Kasir, Pembayaran, Struk, Laporan, Pengaturan, dan gerbang PIN. Tidak ada unit test terpisah untuk perhitungan uang, karena perhitungan itu hanya berarti kalau angkanya benar di layar.

**Prior art**

Satu-satunya test yang ada sekarang adalah widget test bawaan `flutter create` untuk aplikasi counter. Test itu akan diganti seluruhnya; pola yang dipakai tetap widget test biasa tanpa kerangka test tambahan.

**Perilaku yang wajib punya test**

- Wizard awal sampai Transaksi pertama berhasil.
- Penjualan diblokir saat Stok nol, dengan pesan yang bisa dibaca kasir.
- Kuantitas pecahan ditolak pada Satuan bulat dan diterima pada Satuan pecahan.
- Diskon nominal dan persen menghasilkan Total yang benar, termasuk saat Diskon melebihi Subtotal.
- Uang tunai kurang dari Total menolak pembayaran.
- Keranjang bertahan setelah aplikasi dibangun ulang di atas database yang sama.
- Transaksi Batal mengembalikan Stok, menghilangkan Omzet, dan tetap muncul di daftar dengan alasannya.
- PIN menghalangi masuk Pengaturan dan pembatalan Transaksi bila salah.
- Backup diekspor lalu diimpor kembali ke database kosong menghasilkan katalog, Stok, dan Transaksi yang sama.
- Layar kasir menampilkan dua kolom pada lebar tablet dan satu kolom pada lebar HP.

**Catatan**

Nama test memakai istilah dari `GLOSSARY.md` (Transaksi, Keranjang, Stok, Omzet, Transaksi Batal), bukan sinonim yang glossary hindari. Sumber waktu disuntikkan supaya Laporan Harian bisa diuji untuk tanggal tertentu tanpa menunggu pergantian hari.

## Out of Scope

- Sinkronisasi antar-device, backend, akun, dan login (ADR-0001).
- PPN atau pajak apa pun.
- Multi-user, peran, dan shift kas.
- Data pelanggan dan kasbon.
- Pemindaian barcode.
- Printer thermal dan struk kertas.
- QRIS dinamis lewat payment gateway.
- Harga modal, HPP, dan laporan laba.
- Produk terlaris dan rincian per Metode Bayar di laporan.
- Mengubah harga per baris saat menjual.
- Multi-satuan dan konversi dus ke pcs (ADR-0005).
- Menghapus Produk secara permanen (ADR-0004).
- Build iOS — kode sumbernya tetap ada, tapi build-nya butuh macOS.

## Further Notes

- Keputusan yang mengikat ada di `docs/adr/0001`–`0006`. Kalau implementasi menyimpang dari salah satunya, itu harus diangkat sebagai konflik, bukan diam-diam dilanggar.
- Tanpa backend, Backup adalah satu-satunya jaring pengaman. Impor harus benar-benar diuji, bukan dianggap remeh.
- PIN wajib diisi saat wizard — diputuskan, bukan lagi pertanyaan terbuka. Wizard tidak bisa diselesaikan sebelum PIN diisi, karena gerbang PIN yang bisa dilewati tidak melindungi apa pun.
- Format Rupiah memakai titik sebagai pemisah ribuan dan tanpa angka desimal.
- Repo belum punya git. Kalau nanti diinisialisasi, `.scratch/` sebaiknya tetap ikut dilacak karena spec dan tiket tinggal di sana.
