import 'package:flutter/material.dart';

class ProdukScreen extends StatelessWidget {
  const ProdukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produk')),
      body: const Center(child: Text('Belum ada produk')),
    );
  }
}
