import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasir/core/providers.dart';
import 'package:kasir/data/pin_store.dart';
import 'package:kasir/data/toko_store.dart';
import 'package:kasir/features/pin/pin_rules.dart';

/// Wizard yang muncul sekali di awal: mengisi Data Toko dan PIN.
class WizardScreen extends ConsumerStatefulWidget {
  const WizardScreen({super.key});

  @override
  ConsumerState<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends ConsumerState<WizardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _alamat = TextEditingController();
  final _pin = TextEditingController();
  final _pinUlang = TextEditingController();
  bool _menyimpan = false;

  @override
  void dispose() {
    _nama.dispose();
    _alamat.dispose();
    _pin.dispose();
    _pinUlang.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _menyimpan = true);

    final database = ref.read(databaseProvider);
    await TokoStore(database).simpan(
      Toko(nama: _nama.text.trim(), alamat: _alamat.text.trim()),
    );
    await PinStore(database).simpan(_pin.text);

    if (!mounted) return;
    // Layar pembuka membaca Data Toko lewat tokoProvider; membatalkan cache-nya
    // membuat wizard berganti sendiri ke kerangka kasir.
    ref.invalidate(tokoProvider);
  }

  String? _wajibDiisi(String? value, String pesan) =>
      (value == null || value.trim().isEmpty) ? pesan : null;

  String? _validasiPinUlang(String? value) =>
      validasiUlangPin(value, _pin.text);

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Selamat datang', style: teks.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Isi Data Toko dan PIN dulu. Keduanya dipakai untuk struk '
                      'dan mengunci tindakan yang perlu kehati-hatian.',
                      style: teks.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('wizard-nama'),
                      controller: _nama,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama toko',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          _wajibDiisi(value, 'Nama toko wajib diisi'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('wizard-alamat'),
                      controller: _alamat,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Alamat toko',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('wizard-pin'),
                      controller: _pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'PIN',
                        helperText: '4–6 angka',
                        border: OutlineInputBorder(),
                      ),
                      validator: validasiPinBaru,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('wizard-pin-ulang'),
                      controller: _pinUlang,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Ulangi PIN',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validasiPinUlang,
                      onFieldSubmitted: (_) => _simpan(),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('wizard-simpan'),
                      onPressed: _menyimpan ? null : _simpan,
                      child: const Text('Simpan dan mulai'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
