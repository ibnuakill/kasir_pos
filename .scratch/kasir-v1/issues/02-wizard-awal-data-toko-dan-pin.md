# 02: Wizard awal — Data Toko dan PIN

**What to build:** Saat pertama dibuka, wizard meminta nama toko, alamat, dan PIN. Setelah selesai, aplikasi masuk ke layar kasir dan wizard tidak muncul lagi. PIN wajib: wizard tidak bisa diselesaikan tanpa mengisinya.

**Blocked by:** 01 (Kerangka aplikasi & seam test)

**Status:** ready-for-agent

- [ ] Wizard muncul hanya saat Data Toko belum ada
- [ ] Wizard menolak diselesaikan bila nama toko atau PIN kosong
- [ ] PIN tersimpan sebagai hash; tidak ada tempat yang menyimpan PIN apa adanya
- [ ] Setelah wizard selesai, membuka ulang aplikasi langsung ke layar kasir
- [ ] Nama dan alamat toko yang diisi muncul kembali di Pengaturan
