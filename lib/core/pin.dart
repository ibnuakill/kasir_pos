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
    var hash = sha256.convert([...garam, ...utf8.encode(pin)]);
    for (var putaran = 1; putaran < _jumlahPutaran; putaran++) {
      hash = sha256.convert([...hash.bytes, ...garam]);
    }
    return 'v1.${base64Url.encode(garam)}.${base64Url.encode(hash.bytes)}';
  }

  static List<int> _garamAcak() {
    final acak = Random.secure();
    return List<int>.generate(16, (_) => acak.nextInt(256));
  }
}
