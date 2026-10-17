import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/root_gate.dart';

const _seedColor = Color(0xFF2E7D32);

/// Akar aplikasi.
/// Database dan sumber waktu masuk lewat sini, bukan dibuat di dalam, sehingga
/// seluruh aplikasi bisa dijalankan di test terhadap database in-memory dengan
/// waktu tetap.
class KasirApp extends StatelessWidget {
  const KasirApp({super.key, required this.database, required this.clock});

  final AppDatabase database;
  final Clock clock;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        clockProvider.overrideWithValue(clock),
      ],
      child: MaterialApp(
        title: 'Kasir',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(colorSchemeSeed: _seedColor, brightness: Brightness.light),
        darkTheme: ThemeData(colorSchemeSeed: _seedColor, brightness: Brightness.dark),
        home: const RootGate(),
      ),
    );
  }
}
