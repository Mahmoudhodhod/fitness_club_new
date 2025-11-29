import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/src/hex_color.dart';

void main() {
  test("Convert HEX value to Color", () {
    const validColorValue = "#e02121";
    const validColorValue2 = "#212ee0";
    const inValidColorValue1 = "252f";
    const inValidColorValue2 = "8bbbd999";

    expect(getColorFromHex(validColorValue), const Color(0xffe02121));
    expect(getColorFromHex(validColorValue2), const Color(0xff212ee0));
    expect(getColorFromHex(inValidColorValue1), const Color(0x0000252f));
    expect(getColorFromHex(inValidColorValue2), const Color(0x8bbbd999));
  });
}
