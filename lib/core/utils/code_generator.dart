import 'dart:math';

class CodeGenerator {
  static final Random _random = Random();

  static String generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    return List.generate(
      6,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }
}