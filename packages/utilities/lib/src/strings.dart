extension ToDynamicFixedPoint on double {
  ///Converts double to string with a dynamic fraction (fractionDigits = 1)
  ///
  ///Ex1: `num = 60.86` => `str = num.toDynamicFixedOnePoint()` => `60.8`.
  ///
  ///Ex2: `num = 20.0` => `str = num.toDynamicFixedOnePoint()` => `20`.
  String toDynamicFixedOnePoint() {
    final stringAsFixed = toStringAsFixed(1);
    final firstFractionDigit = stringAsFixed.split(".").last;
    final hasZero = firstFractionDigit == "0";
    if (hasZero) {
      return toInt().toString();
    }
    return stringAsFixed;
  }
}

///English matching [RegEx].
final englishRegex = RegExp(r'^(?:[a-zA-Z]|\P{L})+$', unicode: true);

///Checks whether the givin `input` is English string or not.
///
bool isEnglishString(String input) {
  return englishRegex.hasMatch(input);
}

///Arabic matching [RegEx].
final arabicRegex = RegExp(r'^[\u0600-\u06FF]');

///Checks whether the givin `input` is Arabic string or not.
///
bool isArabicString(String input) {
  return arabicRegex.hasMatch(input);
}

const Map<String, String> _numbersMap = {
  '٠': '0',
  '١': '1',
  '٢': '2',
  '٣': '3',
  '٤': '4',
  '٥': '5',
  '٦': '6',
  '٧': '7',
  '٨': '8',
  '٩': '9',
};

extension ArabicToEnglishNumbers on String {
  ///maps Arabic digits to English using [_numbersMap]
  String _mapArabicDigitToEnglish(String digit) {
    return _numbersMap[digit]!;
  }

  ///Checks whether the givin digit string is an Arabic digits or not.
  bool _isNotArabicDigit(String digit) {
    return _numbersMap[digit] == null;
  }

  ///converts the string from Arabic digits to English digits.
  ///
  ///skeps all not digit in [this] String.
  ///
  String toEnglishDigits() {
    return split("").skipANDOperate(_isNotArabicDigit, _mapArabicDigitToEnglish).join();
  }
}

extension Skip<T> on Iterable<T> {
  Iterable<T> skipANDOperate(bool Function(T element) skipTest, T Function(T element) operation) sync* {
    for (final T item in this) {
      yield skipTest(item) ? item : operation(item);
    }
  }
}
