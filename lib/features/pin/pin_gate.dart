import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/features/pin/pin_rules.dart';

/// Gerbang PIN untuk aksi sensitif. Dipakai tab Pengaturan sekarang dan
/// pembatalan transaksi nanti; tidak ada layar yang boleh menulis gerbangnya
/// sendiri. Mengembalikan true hanya bila PIN benar.
Future<bool> mintaPin(BuildContext context) async {
  final benar = await showDialog<bool>(
    context: context,
    builder: (_) => const _PinDialog(),
  );
  return benar ?? false;
}

/// Mengganti PIN. Mengembalikan true bila PIN baru tersimpan.
Future<bool> ubahPin(BuildContext context) async {
  final tersimpan = await showDialog<bool>(
    context: context,
    builder: (_) => const _GantiPinDialog(),
  );
  return tersimpan ?? false;
}

class _PinDialog extends ConsumerStatefulWidget {
  const _PinDialog();

  @override
  ConsumerState<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends ConsumerState<_PinDialog> {
  final _pin = TextEditingController();
  String? _pesanGalat;
  bool _memeriksa = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _periksa() async {
    final pin = _pin.text.trim();
    if (pin.isEmpty) {
      setState(() => _pesanGalat = 'PIN belum diisi');
      return;
    }

    setState(() {
      _memeriksa = true;
      _pesanGalat = null;
    });

    final cocok = await PinStore(ref.read(databaseProvider)).cocok(pin);
    if (!mounted) return;

    if (!cocok) {
      setState(() {
        _memeriksa = false;
        _pesanGalat = 'PIN salah';
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Masukkan PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('pin-input'),
            controller: _pin,
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: const InputDecoration(labelText: 'PIN'),
            onSubmitted: (_) => _periksa(),
          ),
          if (_pesanGalat != null) ...[
            const SizedBox(height: 8),
            Text(
              _pesanGalat!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          key: const Key('pin-batal'),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('pin-buka'),
          onPressed: _memeriksa ? null : _periksa,
          child: const Text('Buka'),
        ),
      ],
    );
  }
}

class _GantiPinDialog extends ConsumerStatefulWidget {
  const _GantiPinDialog();

  @override
  ConsumerState<_GantiPinDialog> createState() => _GantiPinDialogState();
}

class _GantiPinDialogState extends ConsumerState<_GantiPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinBaru = TextEditingController();
  final _pinUlang = TextEditingController();
  bool _menyimpan = false;

  @override
  void dispose() {
    _pinBaru.dispose();
    _pinUlang.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _menyimpan = true);

    await PinStore(ref.read(databaseProvider)).simpan(_pinBaru.text.trim());

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ganti PIN'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const Key('pin-baru'),
              controller: _pinBaru,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: 'PIN baru',
                helperText: '4–6 angka',
              ),
              validator: validasiPinBaru,
            ),
            TextFormField(
              key: const Key('pin-baru-ulang'),
              controller: _pinUlang,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(labelText: 'Ulangi PIN baru'),
              validator: (value) => validasiUlangPin(value, _pinBaru.text),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('pin-baru-simpan'),
          onPressed: _menyimpan ? null : _simpan,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
