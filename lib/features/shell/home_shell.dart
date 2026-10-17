import 'package:flutter/material.dart';
import 'package:kasir/features/kasir/kasir_screen.dart';
import 'package:kasir/features/laporan/laporan_screen.dart';
import 'package:kasir/features/pengaturan/pengaturan_screen.dart';
import 'package:kasir/features/produk/produk_screen.dart';

/// Satu tab: label, ikon, dan layar yang ditampilkan.
typedef _Tab = ({
  String label,
  IconData icon,
  IconData selectedIcon,
  Widget screen,
});

/// Kerangka aplikasi: empat tab yang menjadi rumah seluruh bagian kasir.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// Urutan tab tinggal di satu tempat, sehingga label dan layar tidak bisa
  /// tertukar saat tab baru ditambah.
  static const List<_Tab> _tabs = [
    (
      label: 'Kasir',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
      screen: KasirScreen(),
    ),
    (
      label: 'Produk',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      screen: ProdukScreen(),
    ),
    (
      label: 'Laporan',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      screen: LaporanScreen(),
    ),
    (
      label: 'Pengaturan',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      screen: PengaturanScreen(),
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index].screen,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
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
