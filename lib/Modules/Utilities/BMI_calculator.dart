import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:unit_convert/unit_convert.dart';
import 'package:utilities/utilities.dart';

///BMI table value which describes the user status.
///
enum BMIValue {
  SEVERELY_UNDERWEIGHT,
  UNDERWEIGHT,
  NORMAL,
  OVERWEIGHT,
  OBESE_CLASS,
  UNKNOWN,
}

/// Calculates the User BMI value and return [BMIValue] as an `enum`
/// to describe the user status.
///
class BMICalculator {
  double? _result;

  ///Clears the previous result value.
  ///
  @visibleForTesting
  void clearResult() => _result = null;

  ///Returns the result as a String.
  ///
  String? get resultString {
    return _result?.toDynamicFixedOnePoint();
  }

  ///Calculates the user BMI using his [height] and [weight].
  ///
  ///* [height] is the user's height in `CM`.
  ///* [weight] is the user's weight in `KG`.
  ///
  ///the resulted [BMIValue] is saved and can be used with [result()].
  ///
  double calculate({required double height, required double weight}) {
    double heightInM = LengthUnit.centimeter.to(LengthUnit.meter, height);

    var result = weight / math.pow(heightInM, 2);
    _result = result;
    return result;
  }

  ///Returns the resulted [BMIValue] from the previous
  ///
  ///Must be called after finishing a calculation operation
  ///with [calculate()], otherwise will return `BMIValue.UNKNOWN`.
  ///
  BMIValue result() {
    if (_result == null) return BMIValue.UNKNOWN;
    final result = _result!;
    if (result < 16) {
      return BMIValue.SEVERELY_UNDERWEIGHT;
    } else if (result >= 16 && result <= 18.5) {
      return BMIValue.UNDERWEIGHT;
    } else if (result >= 18.5 && result <= 25) {
      return BMIValue.NORMAL;
    } else if (result >= 25 && result <= 30) {
      return BMIValue.OVERWEIGHT;
    } else {
      return BMIValue.OBESE_CLASS;
    }
  }
}
