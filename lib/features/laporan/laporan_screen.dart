import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/core/rupiah.dart';
import 'package:kasir/core/waktu.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/laporan_store.dart';
import 'package:kasir/features/laporan/laporan_providers.dart';
import 'package:kasir/features/transaksi/detail_transaksi_screen.dart';

/// Tab Laporan: hasil satu hari, dengan tanggal yang bisa digeser.
///
/// Angka Omzet dan jumlah Transaksi berada di atas daftar yang sama, jadi
/// pemilik toko bisa langsung mencocokkan angkanya dengan Transaksi yang
/// tercantum (user story 59, 61).
class LaporanScreen extends ConsumerWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tanggal = ref.watch(tanggalLaporanProvider);
    final hariIni = awalHari(ref.watch(clockProvider)());
    final laporan = ref.watch(laporanHarianProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: Column(
        children: [
          _PemilihTanggal(tanggal: tanggal, hariIni: hariIni),
          _Ringkasan(laporan: laporan.valueOrNull),
          const Divider(height: 1),
          Expanded(
            child: switch (laporan) {
              AsyncData(:final value) => value.kosong
                  ? const _Kosong()
                  : ListView.separated(
                      itemCount: value.transaksi.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) =>
                          _BarisTransaksi(transaksi: value.transaksi[i]),
                    ),
              AsyncError() => const Center(
                child: Text('Laporan gagal dimuat'),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

/// Geser satu hari ke belakang atau ke depan, atau lompat lewat kalender.
class _PemilihTanggal extends ConsumerWidget {
  const _PemilihTanggal({required this.tanggal, required this.hariIni});

  final DateTime tanggal;
  final DateTime hariIni;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bisaMaju = tanggal.isBefore(hariIni);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            key: const Key('laporan-hari-sebelumnya'),
            tooltip: 'Hari sebelumnya',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _geser(ref, -1),
          ),
          Expanded(
            child: InkWell(
              key: const Key('laporan-pilih-tanggal'),
              borderRadius: BorderRadius.circular(8),
              onTap: () => _pilihTanggal(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      formatTanggal(tanggal),
                      key: const Key('laporan-tanggal'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      tanggal == hariIni ? 'Hari ini' : 'Ketuk untuk pilih tanggal',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('laporan-hari-berikutnya'),
            tooltip: 'Hari berikutnya',
            icon: const Icon(Icons.chevron_right),
            // Hari depan tidak perlu dibuka: tidak mungkin ada Transaksi di
            // sana, dan tombol yang tidak berefek lebih membingungkan.
            onPressed: bisaMaju ? () => _geser(ref, 1) : null,
          ),
        ],
      ),
    );
  }

  void _geser(WidgetRef ref, int hari) {
    final tujuan = DateTime(tanggal.year, tanggal.month, tanggal.day + hari);
    ref.read(tanggalLaporanProvider.notifier).state = tujuan;
  }

  Future<void> _pilihTanggal(BuildContext context, WidgetRef ref) async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: tanggal,
      firstDate: DateTime(2020),
      lastDate: hariIni,
      helpText: 'Pilih tanggal laporan',
    );
    if (dipilih == null) return;
    ref.read(tanggalLaporanProvider.notifier).state = awalHari(dipilih);
  }
}

/// Dua angka utama hari itu: Omzet dan jumlah Transaksi.
class _Ringkasan extends StatelessWidget {
  const _Ringkasan({required this.laporan});

  final LaporanHarian? laporan;

  @override
  Widget build(BuildContext context) {
    // Selama data pertama belum datang, angka ditampilkan nol alih-alih
    // kerangka abu-abu: sebentar saja, dan tidak menggeser tata letak.
    final omzet = laporan?.omzet ?? 0;
    final jumlah = laporan?.jumlahTransaksi ?? 0;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _KartuAngka(
              label: 'Omzet',
              nilai: formatRupiah(omzet),
              kunci: const Key('laporan-omzet'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _KartuAngka(
              label: 'Transaksi',
              nilai: '$jumlah',
              kunci: const Key('laporan-jumlah'),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuAngka extends StatelessWidget {
  const _KartuAngka({
    required this.label,
    required this.nilai,
    required this.kunci,
  });

  final String label;
  final String nilai;
  final Key kunci;

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: warna.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            nilai,
            key: kunci,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _BarisTransaksi extends StatelessWidget {
  const _BarisTransaksi({required this.transaksi});

  final TransaksiData transaksi;

  @override
  Widget build(BuildContext context) {
    final tunai = transaksi.metodeBayar == MetodeBayar.tunai;
    final batal = transaksi.batal;
    final warna = Theme.of(context).colorScheme;

    // Transaksi Batal tetap ada di daftar, tapi dicoret dan diberi alasannya
    // supaya tidak terbaca sebagai penjualan yang sah (user story 65).
    final coret = batal ? TextDecoration.lineThrough : null;

    return ListTile(
      key: Key('laporan-transaksi-${transaksi.id}'),
      title: Text(
        transaksi.nomor,
        style: TextStyle(decoration: coret),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${formatJam(transaksi.waktu)} · ${tunai ? 'Tunai' : 'QRIS'}'),
          if (batal)
            Text(
              'Batal · ${transaksi.alasanBatal ?? '-'}',
              key: Key('laporan-batal-${transaksi.id}'),
              style: TextStyle(color: warna.error),
            ),
        ],
      ),
      trailing: Text(
        formatRupiah(transaksi.total),
        key: Key('laporan-total-${transaksi.id}'),
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(decoration: coret),
      ),
      // Membuka Transaksi dari daftar menampilkan detailnya, tempat Struk bisa
      // dibagikan ulang atau Transaksi dibatalkan (user story 62, 63).
      onTap: () => DetailTransaksiScreen.buka(context, transaksi.id),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          const Text('Belum ada Transaksi', key: Key('laporan-kosong')),
        ],
      ),
    );
  }
}
