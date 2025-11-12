class CipherLogic {
  static String atbash(String input) {
    final StringBuffer buffer = StringBuffer();
    for (final int code in input.runes) {
      if (_isUppercase(code)) {
        buffer.writeCharCode('A'.codeUnitAt(0) + ('Z'.codeUnitAt(0) - code));
      } else if (_isLowercase(code)) {
        buffer.writeCharCode('a'.codeUnitAt(0) + ('z'.codeUnitAt(0) - code));
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  static String caesar(String input, int shift) {
    final int normalized = ((shift % 26) + 26) % 26;
    final StringBuffer buffer = StringBuffer();
    for (final int code in input.runes) {
      if (_isUppercase(code)) {
        final int base = 'A'.codeUnitAt(0);
        buffer.writeCharCode(((code - base + normalized) % 26) + base);
      } else if (_isLowercase(code)) {
        final int base = 'a'.codeUnitAt(0);
        buffer.writeCharCode(((code - base + normalized) % 26) + base);
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  static String vigenere(String input, String keyword) {
    if (keyword.isEmpty) return input;
    final List<int> shifts = keyword.runes
        .where((int c) => _isLetter(c))
        .map(
          (int c) =>
              _isUppercase(c) ? c - 'A'.codeUnitAt(0) : c - 'a'.codeUnitAt(0),
        )
        .toList();
    if (shifts.isEmpty) return input;

    final StringBuffer buffer = StringBuffer();
    int keyIndex = 0;
    for (final int code in input.runes) {
      if (_isUppercase(code)) {
        final int base = 'A'.codeUnitAt(0);
        final int shift = shifts[keyIndex % shifts.length];
        buffer.writeCharCode(((code - base + shift) % 26) + base);
        keyIndex++;
      } else if (_isLowercase(code)) {
        final int base = 'a'.codeUnitAt(0);
        final int shift = shifts[keyIndex % shifts.length];
        buffer.writeCharCode(((code - base + shift) % 26) + base);
        keyIndex++;
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  static bool _isUppercase(int code) =>
      code >= 'A'.codeUnitAt(0) && code <= 'Z'.codeUnitAt(0);
  static bool _isLowercase(int code) =>
      code >= 'a'.codeUnitAt(0) && code <= 'z'.codeUnitAt(0);
  static bool _isLetter(int code) => _isUppercase(code) || _isLowercase(code);
}
