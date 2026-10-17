# Satu device, data lokal, tanpa backend

Aplikasi berjalan sepenuhnya offline dengan database lokal di device: tidak ada server, tidak ada akun, tidak ada sinkronisasi antar-device. HP dan tablet memakai build yang sama dengan layout responsif, dan keduanya tidak pernah dipakai bersamaan untuk toko yang sama.

Alternatif yang ditolak: backend cloud (Supabase/Firebase) dengan sinkronisasi multi-device. Ditolak untuk versi ini karena menambah autentikasi, penanganan jaringan, dan resolusi konflik, sementara pemakaian nyatanya satu kasir di satu meja.

Konsekuensi yang perlu diingat: data hanya hidup di satu device. HP hilang atau rusak berarti seluruh riwayat transaksi dan katalog ikut hilang, kecuali ada backup manual.
