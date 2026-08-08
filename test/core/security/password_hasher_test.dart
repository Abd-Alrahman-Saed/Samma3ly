import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/security/password_hasher.dart';

void main() {
  group('PasswordHasher — PBKDF2', () {
    test('hash() ينتج صيغة pbkdf2 موسومة بعدد الدورات', () async {
      final hash = await PasswordHasher.hash('كلمة-سر-قوية', iterations: 1000);
      expect(hash, startsWith('pbkdf2\$1000\$'));
      expect(hash.split('\$'), hasLength(4));
    });

    test('verify() ينجح لنفس كلمة السر ويفشل لكلمة سر خاطئة', () async {
      final hash = await PasswordHasher.hash('سرّ١٢٣', iterations: 1000);
      expect(await PasswordHasher.verify('سرّ١٢٣', hash), isTrue);
      expect(await PasswordHasher.verify('سرّ-غلط', hash), isFalse);
    });

    test('كل نداء hash() يُنتج ملحاً مختلفاً حتى لنفس كلمة السر', () async {
      final h1 = await PasswordHasher.hash('نفس-السر', iterations: 1000);
      final h2 = await PasswordHasher.hash('نفس-السر', iterations: 1000);
      expect(h1, isNot(equals(h2)));
    });

    test('isLegacyFormat() يميّز بين الصيغتين بشكل صحيح', () async {
      final modern = await PasswordHasher.hash('س', iterations: 1000);
      const legacy = 'c29tZXNhbHQ=:abcdef1234567890';
      expect(PasswordHasher.isLegacyFormat(modern), isFalse);
      expect(PasswordHasher.isLegacyFormat(legacy), isTrue);
    });
  });

  group('PasswordHasher — التوافق مع الصيغة القديمة (ما قبل Sprint 0)', () {
    test('verify() ينجح مع تجزئة SHA-256 القديمة الصحيحة', () async {
      // نفس خوارزمية AuthService القديمة قبل 0.8: sha256(password + salt)
      const salt = 'dGVzdC1zYWx0';
      final legacyHash = _legacySha256Hex('كلمة-قديمة', salt);
      final stored = '$salt:$legacyHash';

      expect(await PasswordHasher.verify('كلمة-قديمة', stored), isTrue);
      expect(await PasswordHasher.verify('كلمة-خطأ', stored), isFalse);
    });
  });
}

// نسخة طبق الأصل من AuthService._sha256Hash القديمة (جولة واحدة، بلا ملح
// مُخزَّن منفصل عن النص) — تُستخدم هنا فقط للتأكد من التوافق العكسي في
// PasswordHasher.verify()، لا لإنتاج تجزئات جديدة.
String _legacySha256Hex(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  return sha256.convert(bytes).toString();
}
