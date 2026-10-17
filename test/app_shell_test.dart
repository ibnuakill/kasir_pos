import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/toko_store.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Toko Uji', alamat: 'Jl. Uji No. 1'));
  });
  tearDown(() => database.close());

  KasirApp buildApp() => KasirApp(
    database: database,
    clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
  );

  testWidgets('membuka aplikasi menampilkan empat tab kasir', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    for (final label in ['Kasir', 'Produk', 'Laporan', 'Pengaturan']) {
      expect(find.text(label), findsWidgets, reason: 'tab $label harus ada');
    }
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('berpindah tab menampilkan bagian yang dipilih', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Produk').last);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada produk'), findsOneWidget);

    await tester.tap(find.text('Laporan').last);
    await tester.pumpAndSettle();
    expect(find.text('Belum ada transaksi'), findsOneWidget);

    await tester.tap(find.text('Pengaturan').last);
    await tester.pumpAndSettle();
    expect(find.text('Toko Uji'), findsOneWidget);

    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('aplikasi dibangun ulang di atas database yang sama', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('tema mengikuti mode gelap dan terang perangkat', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Keranjang masih kosong'))).brightness,
      Brightness.dark,
    );

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Keranjang masih kosong'))).brightness,
      Brightness.light,
    );
  });
}
