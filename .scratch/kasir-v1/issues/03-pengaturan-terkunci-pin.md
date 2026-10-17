# 03: Pengaturan terkunci PIN

**What to build:** Tab Pengaturan terbuka hanya setelah PIN benar. Di dalamnya Data Toko bisa diubah dan PIN bisa diganti. Gerbang PIN ini dipakai ulang oleh layar lain, bukan ditulis ulang.

**Blocked by:** 02 (Wizard awal — Data Toko dan PIN)

**Status:** done

- [x] Menekan tab Pengaturan meminta PIN lebih dulu
- [x] PIN salah menolak masuk dengan pesan yang bisa dibaca kasir
- [x] Setelah masuk, nama dan alamat toko bisa diubah dan perubahannya tersimpan
- [x] PIN bisa diganti, dan PIN lama tidak berlaku setelahnya
- [x] Gerbang PIN berbentuk satu mekanisme yang dipakai ulang, bukan dua salinan

## Comments

**2026-10-17 — selesai.** `flutter analyze` bersih, 18 test lulus (13 lama + 5 baru di `test/pengaturan_test.dart`).

Yang jadi:

- `mintaPin(context)` di `lib/features/pin/pin_gate.dart` adalah satu-satunya gerbang PIN. Dialognya privat, jadi tidak ada jalan memanggilnya langsung dan melewati aturan. Pembatalan transaksi di tiket 13 tinggal memanggil fungsi yang sama.
- `ubahPin(context)` memakai dialog terpisah untuk ganti PIN, juga di berkas yang sama.
- `PinHash.cocok` menambah sisi pencocokan yang menggantung di tiket 02, dengan perbandingan yang tidak berhenti di byte pertama yang beda.
- `PinStore` jadi satu-satunya jalan baca/tulis PIN; wizard ikut memakainya.
- `pin_rules.dart` menampung aturan 4–6 angka yang tadinya mau disalin ke wizard dan ke dialog ganti PIN.
- Tab menyimpan `butuhPin` di daftar tabnya, jadi penjagaan tab berikutnya cukup menyalakan satu nilai.

Keputusan yang saya ambil: **PIN diminta setiap kali masuk Pengaturan**, bukan sekali per sesi. Device dipegang bergantian, dan yang perlu dijaga adalah momen masuk. Kalau nanti terasa melelahkan, ubah jadi sekali per sesi di `_pilihTab`.

Catatan yang belum ditutup:

- Tidak ada jeda atau batas percobaan saat PIN salah. Dengan 4–6 angka, tebakan beruntun masih mungkin; 20.000 putaran hash memperlambat tiap percobaan tapi tidak menghentikannya. Belum ada di tiket mana pun.
- Menyimpan Data Toko tidak memberi konfirmasi apa pun. Tombolnya tidak berubah keadaan, jadi kasir tidak tahu sudah tersimpan. SnackBar sengaja dihindari karena timer-nya bikin test rapuh; kalau mau, pakai indikator yang tidak bertimer.
