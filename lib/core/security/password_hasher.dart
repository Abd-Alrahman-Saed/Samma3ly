import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

/// Password hashing with a transparent legacy-upgrade path.
///
/// Stored format (current): `pbkdf2$<iterations>$<saltBase64Url>$<hashBase64Url>`
/// Stored format (legacy, pre-Sprint-0): `<saltBase64Url>:<sha256HexDigest>`
/// — a single SHA-256 round. [AuthService] uses [isLegacyFormat] to detect
/// old hashes and transparently re-hashes them with PBKDF2 on the next
/// successful login, one user at a time — no bulk data migration, no risk
/// of locking anyone out.
class PasswordHasher {
  const PasswordHasher._();

  static const int _defaultIterations = 120000;
  static const int _saltBytes = 16;
  static const int _keyBits = 256;

  static Pbkdf2 _algorithm({int iterations = _defaultIterations}) => Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iterations,
        bits: _keyBits,
      );

  /// Hashes [password] with PBKDF2-HMAC-SHA256 and returns the versioned
  /// stored string (salt + iteration count are embedded, so verification
  /// never needs a separate lookup).
  static Future<String> hash(String password, {int iterations = _defaultIterations}) async {
    final salt = _randomBytes(_saltBytes);
    final secretKey = await _algorithm(iterations: iterations).deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final bytes = await secretKey.extractBytes();
    return 'pbkdf2\$$iterations\$${base64Url.encode(salt)}\$${base64Url.encode(bytes)}';
  }

  /// Returns true if [password] matches [stored], whether it's in the
  /// current PBKDF2 format or the legacy single-round SHA-256 format.
  static Future<bool> verify(String password, String stored) async {
    if (stored.startsWith('pbkdf2\$')) {
      final parts = stored.split('\$');
      if (parts.length != 4) return false;
      final iterations = int.tryParse(parts[1]);
      if (iterations == null) return false;

      final salt = base64Url.decode(parts[2]);
      final expected = base64Url.decode(parts[3]);
      final secretKey = await _algorithm(iterations: iterations).deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final actual = await secretKey.extractBytes();
      return _constantTimeEquals(actual, expected);
    }
    return _verifyLegacy(password, stored);
  }

  /// True only for the legacy pre-Sprint-0 format. [AuthService] checks this
  /// after a successful [verify] to decide whether to transparently re-hash.
  static bool isLegacyFormat(String stored) => !stored.startsWith('pbkdf2\$');

  static Future<bool> _verifyLegacy(String password, String stored) async {
    final parts = stored.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final expectedHex = parts[1];
    final sha256 = Sha256();
    final digest = await sha256.hash(utf8.encode(password + salt));
    final actualHex = digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return _constantTimeEqualsString(actualHex, expectedHex);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static bool _constantTimeEqualsString(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  static List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }
}
