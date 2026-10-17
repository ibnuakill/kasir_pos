import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Melepas pohon widget di dalam test, sebelum test berakhir.
///
/// drift menjadwalkan pembersihan stream lewat timer nol detik saat
/// `ProviderScope` di-dispose. Kalau pohon dilepas setelah test selesai,
/// flutter_test melihat timer itu sebagai kebocoran dan menggagalkan test.
/// Melepas lebih awal lalu memompa sekali memberi timer itu kesempatan jalan.
Future<void> tutupAplikasi(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  // pump() tanpa durasi hanya menguras microtask, bukan timer; drift memakai
  // timer nol detik, jadi waktunya harus dimajukan sedikit.
  await tester.pump(const Duration(milliseconds: 1));
}
