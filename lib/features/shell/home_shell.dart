import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/features/kasir/kasir_screen.dart';
import 'package:kasir/features/laporan/laporan_screen.dart';
import 'package:kasir/features/pengaturan/pengaturan_screen.dart';
import 'package:kasir/features/pin/pin_gate.dart';
import 'package:kasir/features/produk/produk_screen.dart';

/// Satu tab: label, ikon, layar yang ditampilkan, dan apakah tab ini dijaga PIN.
typedef _Tab = ({
  String label,
  IconData icon,
  IconData selectedIcon,
  Widget screen,
  bool butuhPin,
});

/// Kerangka aplikasi: empat tab yang menjadi rumah seluruh bagian kasir.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  /// Urutan tab tinggal di satu tempat, sehingga label dan layar tidak bisa
  /// tertukar saat tab baru ditambah.
  static const List<_Tab> _tabs = [
    (
      label: 'Kasir',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
      screen: KasirScreen(),
      butuhPin: false,
    ),
    (
      label: 'Produk',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      screen: ProdukScreen(),
      butuhPin: false,
    ),
    (
      label: 'Laporan',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      screen: LaporanScreen(),
      butuhPin: false,
    ),
    (
      label: 'Pengaturan',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      screen: PengaturanScreen(),
      butuhPin: true,
    ),
  ];

  int _index = 0;

  Future<void> _pilihTab(int value) async {
    if (value == _index) return;

    // PIN diminta setiap kali masuk Pengaturan, bukan sekali per sesi: device
    // ini dipegang bergantian, dan yang perlu dilindungi adalah momen masuk.
    if (_tabs[value].butuhPin) {
      final terbuka = await mintaPin(context);
      if (!terbuka || !mounted) return;
    }

    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index].screen,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _pilihTab,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
