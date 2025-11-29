import 'package:authentication/authentication.dart' show Gender;
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:the_coach/Widgets/Utilities/calories_table.dart' show CaloriesResult;

enum ActiveLevel {
  BASIC,
  SEDENTARY,
  LIGHT,
  MODETATE,
  VERY_ACTIVE,
  EXTRA_ACTIVE,
  none,
}

///Calculates the User's [DCN]. (calories)
class CaloriesCalculator {
  CaloriesResult calculate({required DCNRequest dcnRequest}) {
    assert(dcnRequest.weight > 0, "Weight must be a positive value");
    assert(dcnRequest.age > 0, "Age must be a positive value");
    assert(dcnRequest.height > 0, "Height must be a positive value");

    final bmr = calculateBMR(dcnRequest);
    final aLevel = activityLevel(dcnRequest.level);
    var result = bmr * aLevel;

    return CaloriesResult(
      toMaintainWeight: bmr,
      toLossHalfKGPerWeek: fractionalChange(result, -0.25),
      toLossKGPerWeek: fractionalChange(result, -0.4),
      toGainHalfKGPerWeek: fractionalChange(result, 0.25),
      toGainKGPerWeek: fractionalChange(result, 0.4),
    );
  }

  @visibleForTesting
  double calculateBMR(DCNRequest dcnRequest) {
    final age = dcnRequest.age;
    final weight = dcnRequest.weight;
    final height = dcnRequest.height;
    final gender = dcnRequest.gender;

    switch (gender) {
      case Gender.male:
        return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      case Gender.female:
        return 447.593 + (9.247 * weight) + (3.098 * height) - (4.33 * age);
      case Gender.others:
        return -1;
    }
  }

  @visibleForTesting
  double activityLevel(ActiveLevel activeLevel) {
    const Map<ActiveLevel, double> levels = {
      ActiveLevel.BASIC: 1.0,
      ActiveLevel.SEDENTARY: 1.2,
      ActiveLevel.LIGHT: 1.375,
      ActiveLevel.MODETATE: 1.5,
      ActiveLevel.VERY_ACTIVE: 1.65,
      ActiveLevel.EXTRA_ACTIVE: 1.8,
    };
    return levels[activeLevel]!;
  }

  @visibleForTesting
  double fractionalChange(double number, double fraction) {
    return number + (number * fraction);
  }
}

class DCNRequest {
  final int age;
  final double height;
  final double weight;
  final Gender gender;
  final ActiveLevel level;

  const DCNRequest({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.level,
  });
}
