/// Aturan PIN, satu tempat untuk wizard dan layar ganti PIN.
///
/// PIN adalah 4–6 angka (lihat GLOSSARY.md), jadi bentuknya diperiksa di sini
/// dan bukan diulang di tiap layar yang meminta PIN.
String? validasiPinBaru(String? value) {
  final pin = value?.trim() ?? '';
  if (pin.isEmpty) return 'PIN wajib diisi';
  if (!RegExp(r'^\d{4,6}$').hasMatch(pin)) return 'PIN harus 4–6 angka';
  return null;
}

String? validasiUlangPin(String? value, String pin) {
  final ulang = value?.trim() ?? '';
  if (ulang.isEmpty) return 'Ulangi PIN wajib diisi';
  if (ulang != pin.trim()) return 'PIN tidak sama';
  return null;
}
