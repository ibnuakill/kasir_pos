# 02: Wizard awal — Data Toko dan PIN

**What to build:** Saat pertama dibuka, wizard meminta nama toko, alamat, dan PIN. Setelah selesai, aplikasi masuk ke layar kasir dan wizard tidak muncul lagi. PIN wajib: wizard tidak bisa diselesaikan tanpa mengisinya.

**Blocked by:** 01 (Kerangka aplikasi & seam test)

**Status:** done

- [x] Wizard muncul hanya saat Data Toko belum ada
- [x] Wizard menolak diselesaikan bila nama toko atau PIN kosong
- [x] PIN tersimpan sebagai hash; tidak ada tempat yang menyimpan PIN apa adanya
- [x] Setelah wizard selesai, membuka ulang aplikasi langsung ke layar kasir
- [x] Nama dan alamat toko yang diisi muncul kembali di Pengaturan

## Comments

**2026-10-17 — selesai.** `flutter analyze` bersih, 13 test lulus (4 lama + 9 baru di `test/wizard_test.dart`).

Yang jadi:

- `RootGate` jadi layar pembuka: membaca `tokoProvider`, menampilkan `WizardScreen` bila Data Toko belum ada, `HomeShell` bila sudah. Wizard tidak perlu memberi tahu siapa pun bahwa ia selesai — ia cukup membatalkan cache `tokoProvider` dan `RootGate` berganti sendiri.
- `TokoStore` membaca dan menulis Data Toko. `null` berarti aplikasi masih baru.
- `SettingKeys` menggantikan kunci bertipe `String` bebas — temuan review tiket 01 sudah ditutup.
- `PinHash.buat` menyimpan `v1.<garam base64>.<hash base64>`: SHA-256 bergaram 16 byte, diulang 20.000 kali. Tidak ada jalur yang menulis PIN apa adanya.
- Wizard juga meminta ulangan PIN. Tidak ada di tiket, tapi PIN yang salah ketik tidak bisa dibatalkan dan mengunci Pengaturan selamanya.

Catatan untuk tiket berikutnya:

- `PinHash` baru bisa membuat hash, belum bisa mencocokkan. Fungsi pencocokan masuk di tiket 03 bersama layar PIN, supaya bentuk simpanannya tidak ditebak dua kali.
- Iterated SHA-256 bukan KDF sekuat PBKDF2/Argon2. Untuk PIN 4–6 angka, ancamannya penyimpanan lokal yang sudah diambil orang, dan garam + 20.000 putaran sudah memperlambat tebakan; menambah dependensi KDF belum sepadan sekarang.
- Saat memuat, `RootGate` menampilkan layar kosong sekejap, bukan indikator. Di perangkat asli ini satu frame; kalau nanti terasa, ganti dengan tampilan awal yang ringan.
