import 'package:flutter/material.dart';
import 'package:kasir/app.dart';
import 'package:kasir/core/clock.dart';
import 'package:kasir/data/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    KasirApp(
      database: AppDatabase(openAppDatabase()),
      clock: systemClock(),
    ),
  );
}
