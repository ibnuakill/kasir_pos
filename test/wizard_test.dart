import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/data/setting_keys.dart';

import 'bantuan.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.inMemory());
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

  Future<void> isiWizard(
    WidgetTester tester, {
    String nama = 'Warung Bu Sri',
    String alamat = 'Jl. Melati 12',
    String pin = '1234',
    String? pinUlang,
  }) async {
    await tester.enterText(find.byKey(const Key('wizard-nama')), nama);
    await tester.enterText(find.byKey(const Key('wizard-alamat')), alamat);
    await tester.enterText(find.byKey(const Key('wizard-pin')), pin);
    await tester.enterText(
      find.byKey(const Key('wizard-pin-ulang')),
      pinUlang ?? pin,
    );
  }

  Future<void> tekanSimpan(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('wizard-simpan')));
    await tester.pumpAndSettle();
  }

  testWidgets('wizard muncul saat Data Toko belum ada', (tester) async {
    await bukaAplikasi(tester);

    expect(find.byKey(const Key('wizard-nama')), findsOneWidget);
    expect(find.byKey(const Key('wizard-pin')), findsOneWidget);
    expect(find.text('Keranjang masih kosong'), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('wizard menolak diselesaikan bila nama toko kosong', (
    tester,
  ) async {
    await bukaAplikasi(tester);
    await isiWizard(tester, nama: '');
    await tekanSimpan(tester);

    expect(find.text('Nama toko wajib diisi'), findsOneWidget);
    expect(find.byKey(const Key('wizard-nama')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('wizard menolak diselesaikan bila PIN kosong', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester, pin: '', pinUlang: '');
    await tekanSimpan(tester);

    expect(find.text('PIN wajib diisi'), findsOneWidget);
    expect(find.byKey(const Key('wizard-pin')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('wizard menolak PIN yang bukan 4 sampai 6 angka', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester, pin: '12', pinUlang: '12');
    await tekanSimpan(tester);

    expect(find.text('PIN harus 4–6 angka'), findsOneWidget);
    expect(find.byKey(const Key('wizard-pin')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('wizard menolak bila ulangan PIN tidak sama', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester, pin: '1234', pinUlang: '4321');
    await tekanSimpan(tester);

    expect(find.text('PIN tidak sama'), findsOneWidget);
    expect(find.byKey(const Key('wizard-pin')), findsOneWidget);

    await tutupAplikasi(tester);
  });

  testWidgets('setelah wizard selesai aplikasi masuk ke layar kasir', (
    tester,
  ) async {
    await bukaAplikasi(tester);
    await isiWizard(tester);
    await tekanSimpan(tester);

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(find.byKey(const Key('wizard-nama')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('membuka ulang aplikasi langsung ke layar kasir', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester);
    await tekanSimpan(tester);

    await bukaAplikasi(tester);

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
    expect(find.byKey(const Key('wizard-nama')), findsNothing);

    await tutupAplikasi(tester);
  });

  testWidgets('Pengaturan menampilkan nama dan alamat toko', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester);
    await tekanSimpan(tester);

    await tester.tap(find.text('Pengaturan').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('pin-input')), '1234');
    await tester.tap(find.byKey(const Key('pin-buka')));
    await tester.pumpAndSettle();

    expect(find.text('Warung Bu Sri'), findsOneWidget);
    expect(find.text('Jl. Melati 12'), findsOneWidget);

    await tutupAplikasi(tester);
  });

  // PIN tidak pernah terlihat di layar, jadi satu-satunya cara memeriksa
  // janji "tidak disimpan apa adanya" adalah membaca isi penyimpanan langsung.
  testWidgets('PIN tersimpan sebagai hash, bukan apa adanya', (tester) async {
    await bukaAplikasi(tester);
    await isiWizard(tester, pin: '1234');
    await tekanSimpan(tester);

    final tersimpan = await database.getSetting(SettingKeys.pinHash);

    expect(tersimpan, isNotNull);
    expect(tersimpan, isNot(contains('1234')));
    expect(tersimpan!.length, greaterThan(20));

    await tutupAplikasi(tester);
  });
}
