import 'package:flutter/material.dart';
import 'package:kasir/core/diskon.dart';
import 'package:kasir/core/rupiah.dart';

/// Hasil dialog Diskon. `hapus` dibedakan dari `diskon == null` supaya
/// menutup dialog tanpa memilih (batal) tidak menghapus Diskon yang ada.
class HasilDiskon {
  const HasilDiskon.simpan(Diskon this.diskon) : hapus = false;
  const HasilDiskon.hapus() : diskon = null, hapus = true;

  final Diskon? diskon;
  final bool hapus;
}

/// Menanyakan Diskon Transaksi. Mengembalikan null bila kasir membatalkan.
Future<HasilDiskon?> tanyaDiskon(
  BuildContext context, {
  required int subtotal,
  Diskon? sekarang,
}) {
  return showDialog<HasilDiskon>(
    context: context,
    builder: (_) => _DialogDiskon(subtotal: subtotal, sekarang: sekarang),
  );
}

class _DialogDiskon extends StatefulWidget {
  const _DialogDiskon({required this.subtotal, this.sekarang});

  final int subtotal;
  final Diskon? sekarang;

  @override
  State<_DialogDiskon> createState() => _DialogDiskonState();
}

class _DialogDiskonState extends State<_DialogDiskon> {
  late JenisDiskon _jenis = widget.sekarang?.jenis ?? JenisDiskon.nominal;
  late final TextEditingController _nilai = TextEditingController(
    text: widget.sekarang == null ? '' : widget.sekarang!.nilai.toString(),
  );
  String? _galat;

  @override
  void dispose() {
    _nilai.dispose();
    super.dispose();
  }

  void _gantiJenis(JenisDiskon jenis) {
    setState(() {
      _jenis = jenis;
      _galat = null;
      _nilai.clear();
    });
  }

  void _simpan() {
    final galat = validasiDiskon(_nilai.text, jenis: _jenis);
    if (galat != null) {
      setState(() => _galat = galat);
      return;
    }

    final nilai = _jenis == JenisDiskon.nominal
        ? parseRupiah(_nilai.text)!
        : int.parse(_nilai.text.replaceAll(RegExp(r'[^0-9]'), ''));

    Navigator.of(context).pop(
      HasilDiskon.simpan(Diskon(jenis: _jenis, nilai: nilai)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nominal = _jenis == JenisDiskon.nominal;

    return AlertDialog(
      title: const Text('Diskon'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<JenisDiskon>(
            segments: const [
              ButtonSegment(
                value: JenisDiskon.nominal,
                label: Text('Nominal', key: Key('diskon-jenis-nominal')),
              ),
              ButtonSegment(
                value: JenisDiskon.persen,
                label: Text('Persen', key: Key('diskon-jenis-persen')),
              ),
            ],
            selected: {_jenis},
            onSelectionChanged: (pilihan) => _gantiJenis(pilihan.first),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('diskon-nilai'),
            controller: _nilai,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: nominal ? 'Nominal' : 'Persen',
              prefixText: nominal ? 'Rp' : null,
              suffixText: nominal ? null : '%',
              errorText: _galat,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _simpan(),
          ),
          const SizedBox(height: 8),
          Text('Subtotal ${formatRupiah(widget.subtotal)}'),
        ],
      ),
      actions: [
        if (widget.sekarang != null)
          TextButton(
            key: const Key('diskon-hapus'),
            onPressed: () =>
                Navigator.of(context).pop(const HasilDiskon.hapus()),
            child: const Text('Hapus Diskon'),
          ),
        TextButton(
          key: const Key('diskon-batal'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('diskon-simpan'),
          onPressed: _simpan,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
