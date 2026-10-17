/// Sumber waktu aplikasi.
///
/// Semua bagian yang butuh "sekarang" meminta lewat ini, bukan memanggil
/// `DateTime.now()` langsung, supaya Laporan Harian dan nomor Transaksi bisa
/// diuji untuk tanggal tertentu tanpa menunggu pergantian hari.
typedef Clock = DateTime Function();

/// Jam yang selalu menjawab waktu yang sama. Dipakai di test.
Clock fixedClock(DateTime instant) => () => instant;

/// Jam perangkat sungguhan. Dipakai saat aplikasi berjalan.
Clock systemClock() => DateTime.now;
