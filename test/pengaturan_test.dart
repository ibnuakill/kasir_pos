import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/toko_store.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.inMemory();
    await TokoStore(
      database,
    ).simpan(const Toko(nama: 'Warung Bu Sri', alamat: 'Jl. Melati 12'));
    await PinStore(database).simpan('1234');
  });
  tearDown(() => database.close());

  Future<void> bukaAplikasi(WidgetTester tester) async {
    await tester.pumpWidget(
      KasirApp(
        database: database,
        clock: fixedClock(DateTime(2026, 10, 17, 9, 30)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tekanTabPengaturan(WidgetTester tester) async {
    await tester.tap(find.text('Pengaturan').last);
    await tester.pumpAndSettle();
  }

  Future<void> masukkanPin(WidgetTester tester, String pin) async {
    await tester.enterText(find.byKey(const Key('pin-input')), pin);
    await tester.tap(find.byKey(const Key('pin-buka')));
    await tester.pumpAndSettle();
  }

  Future<void> bukaPengaturan(WidgetTester tester, {String pin = '1234'}) async {
    await tekanTabPengaturan(tester);
    await masukkanPin(tester, pin);
  }

  testWidgets('menekan tab Pengaturan meminta PIN lebih dulu', (tester) async {
    await bukaAplikasi(tester);
    await tekanTabPengaturan(tester);

    expect(find.byKey(const Key('pin-input')), findsOneWidget);
    expect(find.byKey(const Key('data-toko-nama')), findsNothing);
  });

  testWidgets('PIN salah ditolak dengan pesan yang terbaca', (tester) async {
    await bukaAplikasi(tester);
    await tekanTabPengaturan(tester);
    await masukkanPin(tester, '9999');

    expect(find.text('PIN salah'), findsOneWidget);
    expect(find.byKey(const Key('data-toko-nama')), findsNothing);
  });

  testWidgets('PIN benar membuka Pengaturan', (tester) async {
    await bukaAplikasi(tester);
    await bukaPengaturan(tester);

    expect(find.byKey(const Key('data-toko-nama')), findsOneWidget);
    expect(find.text('Warung Bu Sri'), findsOneWidget);
    expect(find.text('Jl. Melati 12'), findsOneWidget);
  });

  testWidgets('nama dan alamat toko bisa diubah dan tersimpan', (tester) async {
    await bukaAplikasi(tester);
    await bukaPengaturan(tester);

    await tester.enterText(
      find.byKey(const Key('data-toko-nama')),
      'Warung Bu Sri Baru',
    );
    await tester.enterText(
      find.byKey(const Key('data-toko-alamat')),
      'Jl. Baru 9',
    );
    await tester.tap(find.byKey(const Key('data-toko-simpan')));
    await tester.pumpAndSettle();

    // Masih di Pengaturan: menyimpan tidak boleh melempar kasir keluar.
    expect(find.byKey(const Key('data-toko-nama')), findsOneWidget);

    // Pergi lalu kembali: yang tampil harus datang dari penyimpanan, bukan dari
    // isi kolom yang tadi diketik.
    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();
    await bukaPengaturan(tester);

    expect(find.text('Warung Bu Sri Baru'), findsOneWidget);
    expect(find.text('Jl. Baru 9'), findsOneWidget);
  });

  testWidgets('PIN bisa diganti dan PIN lama tidak berlaku lagi', (tester) async {
    await bukaAplikasi(tester);
    await bukaPengaturan(tester);

    await tester.tap(find.byKey(const Key('ganti-pin')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('pin-baru')), '5678');
    await tester.enterText(find.byKey(const Key('pin-baru-ulang')), '5678');
    await tester.tap(find.byKey(const Key('pin-baru-simpan')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kasir').last);
    await tester.pumpAndSettle();

    await tekanTabPengaturan(tester);
    await masukkanPin(tester, '1234');
    expect(find.text('PIN salah'), findsOneWidget);
    expect(find.byKey(const Key('data-toko-nama')), findsNothing);

    await masukkanPin(tester, '5678');
    expect(find.byKey(const Key('data-toko-nama')), findsOneWidget);
  });
}
