import 'package:authentication/authentication.dart';
import 'package:flutter/foundation.dart';

import 'BMI_calculator.dart';

@deprecated
enum FatState {
  under,
  healthy,
  overweight,
  obese,
}

@deprecated
@immutable
class FatResult {
  final double fatPersentage;
  final AgeData ageData;
  final FatState state;
  final Gender gender;

  const FatResult({
    required this.fatPersentage,
    required this.ageData,
    required this.state,
    required this.gender,
  });
}

@deprecated
class FatCalculator {
  Map<Gender, List<AgeData>> _dataMap = {
    Gender.male: const [
      AgeData.twentyToForty([
        StateData(FatState.under, Range(double.negativeInfinity, .08)),
        StateData(FatState.healthy, Range(0.081, .19)),
        StateData(FatState.overweight, Range(0.191, .25)),
        StateData(FatState.obese, Range(0.251)),
      ]),
      AgeData.fortyToSixty([
        StateData(FatState.under, Range(double.negativeInfinity, .11)),
        StateData(FatState.healthy, Range(0.111, .22)),
        StateData(FatState.overweight, Range(0.221, .27)),
        StateData(FatState.obese, Range(0.271)),
      ]),
      AgeData.sixtyToSeventy([
        StateData(FatState.under, Range(double.negativeInfinity, .13)),
        StateData(FatState.healthy, Range(0.131, .25)),
        StateData(FatState.overweight, Range(0.251, .30)),
        StateData(FatState.obese, Range(0.301)),
      ]),
    ],
    Gender.female: const [
      AgeData.twentyToForty([
        StateData(FatState.under, Range(double.negativeInfinity, .21)),
        StateData(FatState.healthy, Range(0.211, .33)),
        StateData(FatState.overweight, Range(0.331, .39)),
        StateData(FatState.obese, Range(0.391)),
      ]),
      AgeData.fortyToSixty([
        StateData(FatState.under, Range(double.negativeInfinity, .32)),
        StateData(FatState.healthy, Range(0.231, .35)),
        StateData(FatState.overweight, Range(0.351, .40)),
        StateData(FatState.obese, Range(0.401)),
      ]),
      AgeData.sixtyToSeventy([
        StateData(FatState.under, Range(double.negativeInfinity, .24)),
        StateData(FatState.healthy, Range(0.241, .36)),
        StateData(FatState.overweight, Range(0.361, .42)),
        StateData(FatState.obese, Range(0.421)),
      ]),
    ],
  };

  @visibleForTesting
  FatResult find({
    required Gender gender,
    required int age,
    required double persentage,
  }) {
    assert(persentage <= 0.95);

    final _gender = _dataMap[gender]!;
    final ageData = _gender.firstWhere((data) => data.inRange(age));
    final state = ageData.stateData.firstWhere((data) => data.inRange(persentage)).state;

    return FatResult(
      fatPersentage: persentage,
      ageData: ageData,
      state: state,
      gender: gender,
    );
  }

  @visibleForTesting
  double calculateFatPersentage({
    required Gender gender,
    required int age,
    required double weight,
    required double height,
  }) {
    final bmiValue = BMICalculator().calculate(height: height, weight: weight);
    double result = (1.20 * bmiValue) + (0.23 * age);
    if (gender == Gender.male) return result - 16.2;
    return result - 5.4;
  }

  FatResult calculate({
    required Gender gender,
    required int age,
    required double weight,
    required double height,
  }) {
    final persentage = calculateFatPersentage(gender: gender, age: age, weight: weight, height: height) / 100;
    return find(gender: gender, age: age, persentage: persentage);
  }
}

@deprecated
@visibleForTesting
class Range {
  final num min;
  final num max;
  const Range([this.min = double.negativeInfinity, this.max = double.infinity]);
  bool inRange(num value) => value >= min && value <= max;

  @override
  String toString() => 'Range(min: $min, max: $max)';

  String toVisiableString() {
    String newMin = '';
    String newMax = '';
    if (min != double.negativeInfinity) newMin = (min * 100).toStringAsFixed(0);
    if (max != double.infinity) newMax = (max * 100).toStringAsFixed(0);
    if (newMin.isEmpty) return "$newMax%";
    if (newMax.isEmpty) return "$newMin%";
    return "$newMin% - $newMax%";
  }
}

@deprecated
@visibleForTesting
class StateData {
  final FatState state;
  final Range persentage;

  const StateData(this.state, this.persentage);

  bool inRange(double persentageV) => persentage.inRange(persentageV);

  @override
  String toString() => 'SubData(state: $state, persentage: $persentage)';
}

@deprecated
@visibleForTesting
class AgeData {
  final Range age;
  final List<StateData> stateData;

  const AgeData.twentyToForty(this.stateData) : age = const Range(20, 40);
  const AgeData.fortyToSixty(this.stateData) : age = const Range(41, 60);
  const AgeData.sixtyToSeventy(this.stateData) : age = const Range(61, 79);

  bool inRange(int ageV) => age.inRange(ageV);

  @override
  String toString() => '_Data(age: $age, data: $stateData)';
}
