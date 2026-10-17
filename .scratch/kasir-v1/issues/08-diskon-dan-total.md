# 08: Diskon dan Total

**What to build:** Diskon di level Transaksi, berupa nominal rupiah atau persen dari Subtotal, dengan Total yang berubah seketika dan tidak pernah kurang dari nol.

**Blocked by:** 07 (Layar kasir — katalog dan Keranjang)

**Status:** done

- [x] Diskon nominal mengurangi Total sesuai angka yang dimasukkan
- [x] Diskon persen menghitung potongan dari Subtotal dan dibulatkan ke rupiah terdekat
- [x] Diskon yang melebihi Subtotal menghasilkan Total nol, bukan angka minus
- [x] Diskon bisa dihapus sehingga Total kembali sama dengan Subtotal
- [x] Diskon hanya ada di level Transaksi; tidak ada cara memotong harga satu baris

## Comments

**2026-10-17** — Diskon disimpan di dalam `IsiKeranjang` bersama baris, jadi Subtotal, Diskon, dan Total dihitung dari satu sumber dan tidak mungkin bertentangan. `hitungPotongan` memakai aritmetika bulat (`(subtotal * persen + 50) ~/ 100`, tanpa `double`) lalu dijepit ke `0..subtotal`, sehingga Total nol ketika Diskon melebihi Subtotal. Diskon persen divalidasi 0–100 di dialog; jepitan tetap berlaku bila nilai lolos. Baris Diskon di panel Keranjang hanya menampilkan persennya (nominal sudah terlihat sebagai potongan). Diskon ikut terhapus saat baris terakhir dihapus, supaya belanja berikutnya tidak mewarisi potongan lama. 68 test lulus.
