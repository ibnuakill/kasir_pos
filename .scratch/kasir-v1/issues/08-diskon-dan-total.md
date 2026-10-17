# 08: Diskon dan Total

**What to build:** Diskon di level Transaksi, berupa nominal rupiah atau persen dari Subtotal, dengan Total yang berubah seketika dan tidak pernah kurang dari nol.

**Blocked by:** 07 (Layar kasir — katalog dan Keranjang)

**Status:** ready-for-agent

- [ ] Diskon nominal mengurangi Total sesuai angka yang dimasukkan
- [ ] Diskon persen menghitung potongan dari Subtotal dan dibulatkan ke rupiah terdekat
- [ ] Diskon yang melebihi Subtotal menghasilkan Total nol, bukan angka minus
- [ ] Diskon bisa dihapus sehingga Total kembali sama dengan Subtotal
- [ ] Diskon hanya ada di level Transaksi; tidak ada cara memotong harga satu baris
