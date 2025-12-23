// lib/core/utils/uuid_generator.dart
import 'dart:math';

class UuidGenerator {
  static String generate() {
    return _generateV4();
  }

  static String _generateV4() {
    var uuid = <int>[];
    var r = Random();

    for (var i = 0; i < 16; i++) {
      uuid.add(r.nextInt(255));
    }

    // Set version to 4
    uuid[6] = (uuid[6] & 0x0f) | 0x40;
    // Set variant to 2
    uuid[8] = (uuid[8] & 0x3f) | 0x80;

    var byteToHex = (int byte) => byte.toRadixString(16).padLeft(2, '0');
    var hex = uuid.map(byteToHex).join('');

    return [
      hex.substring(0, 8),
      hex.substring(8, 12),
      hex.substring(12, 16),
      hex.substring(16, 20),
      hex.substring(20, 32)
    ].join('-');
  }
}