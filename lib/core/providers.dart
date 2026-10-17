import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';

/// Database aplikasi. Selalu diisi oleh [KasirApp], sehingga tidak ada bagian
/// aplikasi yang membuka database sendiri.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('databaseProvider harus diisi oleh KasirApp'),
);

/// Sumber waktu aplikasi. Selalu diisi oleh [KasirApp].
final clockProvider = Provider<Clock>(
  (ref) => throw StateError('clockProvider harus diisi oleh KasirApp'),
);
