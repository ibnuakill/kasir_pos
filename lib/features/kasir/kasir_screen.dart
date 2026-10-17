import 'package:flutter/material.dart';

class KasirScreen extends StatelessWidget {
  const KasirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir')),
      body: const Center(child: Text('Keranjang masih kosong')),
    );
  }
}
