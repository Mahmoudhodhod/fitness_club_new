import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/src/strings.dart';

void main() {
  group("toEnglishtoEnglishDigitsAlpa()", () {
    test("returns [English] digits when all digits are in [Arabic]", () {
      expect("٠١٤٧٨٩٦٣٢٥".toEnglishDigits(), "0147896325");
      expect("٠١٥٥١٥٤٥٩٧٣".toEnglishDigits(), "01551545973");
      expect("٩٠٠٥٥٥".toEnglishDigits(), "900555");
    });
    test("returns [English] digits when some digits are in [Arabic]", () {
      expect("#١٢٣٤٥٦@".toEnglishDigits(), "#123456@");
      expect("+٢٠١٥٥١٥٤٥٩٧٣".toEnglishDigits(), "+201551545973");
      expect("+٢٠١٥٥-١٥٤٥٩٧٣".toEnglishDigits(), "+20155-1545973");
    });
  });

  group("isEnglishString", () {
    const validArabicString = "انا اسمي احمد محمود";
    const mixedArabicAndEnglishText = "انا مطور Flutter";
    const validEnglishString = "My name is Ahmed Mahmoud";
    test(
      "returns [true] if givin a valid "
      "English string",
      () {
        expect(isEnglishString(validEnglishString), isTrue);
      },
    );
    test(
      "returns [false] if givin a invalid "
      "English string",
      () {
        expect(isEnglishString(validArabicString), isFalse);
      },
    );
    test(
      "returns [false] if givin a mixed "
      "English and Arabic string",
      () {
        expect(isEnglishString(mixedArabicAndEnglishText), isFalse);
      },
    );
  });
  group("isArabicString [dirty]", () {
    const validArabicString = "انا اسمي احمد محمود";
    const englishString = "My name is Ahmed Mahmoud";
    test(
      "returns [true] if givin a valid "
      "Arabic string",
      () {
        expect(isArabicString(validArabicString), isTrue);
      },
    );
    test(
      "returns [false] if givin a invalid "
      "English string",
      () {
        expect(isArabicString(englishString), isFalse);
      },
    );
  });
}
