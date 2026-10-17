import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasir/core/kuantitas.dart';
import 'package:kasir/data/database.dart';
import 'package:kasir/features/stok/stok_rules.dart';

/// Menanyakan satu jumlah Stok. Hasilnya kuantitas berskala seribu, atau null
/// kalau kasir membatalkan.
///
/// [koreksi] membedakan dua pertanyaan yang mirip: Tambah Stok menanyakan
/// berapa yang masuk, Koreksi Stok menanyakan berapa hasil hitung fisik.
Future<int?> tanyaJumlahStok(
  BuildContext context, {
  required ProdukData produk,
  required int stokSekarang,
  required bool koreksi,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) => _JumlahStokDialog(
      produk: produk,
      stokSekarang: stokSekarang,
      koreksi: koreksi,
    ),
  );
}

class _JumlahStokDialog extends StatefulWidget {
  const _JumlahStokDialog({
    required this.produk,
    required this.stokSekarang,
    required this.koreksi,
  });

  final ProdukData produk;
  final int stokSekarang;
  final bool koreksi;

  @override
  State<_JumlahStokDialog> createState() => _JumlahStokDialogState();
}

class _JumlahStokDialogState extends State<_JumlahStokDialog> {
  final _formKey = GlobalKey<FormState>();
  final _jumlah = TextEditingController();

  @override
  void dispose() {
    _jumlah.dispose();
    super.dispose();
  }

  void _kirim() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(parseKuantitas(_jumlah.text));
  }

  @override
  Widget build(BuildContext context) {
    final koreksi = widget.koreksi;

    return AlertDialog(
      title: Text(koreksi ? 'Koreksi Stok' : 'Tambah Stok'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: Key(koreksi ? 'stok-koreksi-jumlah' : 'stok-jumlah'),
          controller: _jumlah,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\-]')),
          ],
          decoration: InputDecoration(
            labelText: koreksi ? 'Stok hasil hitung' : 'Jumlah masuk',
            suffixText: widget.produk.satuan,
            helperText: koreksi
                ? 'Stok sekarang: ${formatKuantitas(widget.stokSekarang)}'
                : null,
            border: const OutlineInputBorder(),
          ),
          validator: (value) => validasiJumlahStok(
            value,
            bolehPecahan: widget.produk.bolehPecahan,
            bolehNol: koreksi,
          ),
          onFieldSubmitted: (_) => _kirim(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: Key(koreksi ? 'stok-koreksi-simpan' : 'stok-simpan'),
          onPressed: _kirim,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
