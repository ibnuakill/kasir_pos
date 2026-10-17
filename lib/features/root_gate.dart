import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/features/shell/home_shell.dart';
import 'package:kasir/features/wizard/wizard_screen.dart';

/// Layar pembuka: wizard saat Data Toko belum ada, kerangka kasir sesudahnya.
///
/// Satu-satunya pembaca Data Toko di lapisan ini adalah [tokoProvider], jadi
/// wizard cukup membatalkan cache-nya dan layar ini berganti sendiri.
class RootGate extends ConsumerWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(tokoProvider)
        .when(
          loading: () => const Scaffold(body: SizedBox.shrink()),
          error: (error, _) => Scaffold(
            body: Center(child: Text('Gagal memuat Data Toko: $error')),
          ),
          data: (toko) =>
              toko == null ? const WizardScreen() : const HomeShell(),
        );
  }
}
