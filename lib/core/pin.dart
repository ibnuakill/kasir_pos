import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// PIN tidak pernah disimpan apa adanya. Yang disimpan hanya hash bergaram,
/// dalam bentuk `v1.<garam base64>.<hash base64>`.
abstract final class PinHash {
  /// Cukup mahal untuk memperlambat tebakan, cukup murah untuk tidak terasa
  /// saat PIN dimasukkan.
  static const _jumlahPutaran = 20000;

  static String buat(String pin) {
    final garam = _garamAcak();
    return 'v1.${base64Url.encode(garam)}.${base64Url.encode(_hash(pin, garam))}';
  }

  /// Membandingkan PIN dengan simpanan hasil [buat].
  static bool cocok(String pin, String tersimpan) {
    final bagian = tersimpan.split('.');
    if (bagian.length != 3 || bagian[0] != 'v1') return false;
    final garam = base64Url.decode(bagian[1]);
    final diharapkan = base64Url.decode(bagian[2]);
    return _samaPersis(_hash(pin, garam), diharapkan);
  }

  static List<int> _hash(String pin, List<int> garam) {
    var hash = sha256.convert([...garam, ...utf8.encode(pin)]);
    for (var putaran = 1; putaran < _jumlahPutaran; putaran++) {
      hash = sha256.convert([...hash.bytes, ...garam]);
    }
    return hash.bytes;
  }

  /// Perbandingan yang tidak berhenti di byte pertama yang berbeda.
  static bool _samaPersis(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var beda = 0;
    for (var i = 0; i < a.length; i++) {
      beda |= a[i] ^ b[i];
    }
    return beda == 0;
  }

  static List<int> _garamAcak() {
    final acak = Random.secure();
    return List<int>.generate(16, (_) => acak.nextInt(256));
  }
}
