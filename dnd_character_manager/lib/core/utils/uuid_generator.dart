// lib/core/utils/uuid_generator.dart
import 'dart:math';

class UuidGenerator {
  static String generate() {
    final random = Random();
    final buffer = StringBuffer();
    
    for (int i = 0; i < 8; i++) {
      buffer.write(_nextInt(random, 16).toRadixString(16));
    }
    buffer.write('-');
    for (int i = 0; i < 4; i++) {
      buffer.write(_nextInt(random, 16).toRadixString(16));
    }
    buffer.write('-');
    for (int i = 0; i < 4; i++) {
      buffer.write(_nextInt(random, 16).toRadixString(16));
    }
    buffer.write('-');
    for (int i = 0; i < 4; i++) {
      buffer.write(_nextInt(random, 16).toRadixString(16));
    }
    buffer.write('-');
    for (int i = 0; i < 12; i++) {
      buffer.write(_nextInt(random, 16).toRadixString(16));
    }
    
    return buffer.toString();
  }
  
  static int _nextInt(Random random, int max) {
    return random.nextInt(max);
  }
}