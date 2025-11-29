import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/src/degree_to_rad.dart';

extension on double {
  double clipToTwoFloatingDigits() => double.parse(toStringAsFixed(2));
}

void main() {
  test("Test conversion from Degrees to Radian", () {
    expect(degreeToRad(0), 0);
    expect(degreeToRad(45).clipToTwoFloatingDigits(), (-0.7853982).clipToTwoFloatingDigits());
    expect(degreeToRad(90).clipToTwoFloatingDigits(), (-1.570796).clipToTwoFloatingDigits());
    expect(degreeToRad(180).clipToTwoFloatingDigits(), (-3.141593).clipToTwoFloatingDigits());
    expect(degreeToRad(360).clipToTwoFloatingDigits(), (-6.283185).clipToTwoFloatingDigits());
  });
}
