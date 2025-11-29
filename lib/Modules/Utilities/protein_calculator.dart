import 'package:authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:unit_convert/unit_convert.dart';

import 'package:utilities/utilities.dart';

///User fitness exercise level.
///
enum FitnessLevel {
  NO_EXERCISE,
  LOW_LEVEL_TRAINING,
  ACTIVE_LEVEL_TRAINING,
  SPORTS,
  WEIGHT_TRAINING,
}

class ProteinCalculator {
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

  ///Get the protein average level form gender specs in `gm`.
  ///
  ///Returns in [GM].
  @visibleForTesting
  double getProtein(Gender gender, FitnessLevel level, Specs specs) {
    switch (level) {
      case FitnessLevel.NO_EXERCISE:
        return specs.noExercise;
      case FitnessLevel.LOW_LEVEL_TRAINING:
        return specs.lowLevelTraining;
      case FitnessLevel.ACTIVE_LEVEL_TRAINING:
        return specs.activeLevelTraining;
      case FitnessLevel.SPORTS:
        return specs.sports;
      case FitnessLevel.WEIGHT_TRAINING:
        return specs.weightTrainingMuscleGain;
    }
  }

  ///Calculates the user Protein intake using his [weight], [gender] and [ActivityLevel].
  ///
  ///* [weight] is the user's weight in `KG`.
  ///
  ///Result is in `GM`.
  double calculate({
    required double weight,
    required Gender gender,
    required FitnessLevel level,
  }) {
    assert(weight > 0, "Weight must be a positive value");
    final Specs specs = gender == Gender.male ? MaleSpecs() : FemaleSpecs();
    final genderAverageIMGM = getProtein(gender, level, specs);
    final average = WeightUnit.gram.to(WeightUnit.kilogram, genderAverageIMGM);
    var result = WeightUnit.kilogram.to(WeightUnit.gram, weight * average);
    _result = result;
    return result;
  }
}

///The gender specific exercises specs.
///
abstract class Specs {
  double get noExercise {
    throw UnimplementedError("impalement [noExercise] and try again.");
  }

  double get lowLevelTraining {
    throw UnimplementedError("impalement [lowLevelTraining] and try again.");
  }

  double get activeLevelTraining {
    throw UnimplementedError("impalement [activeLevelTraining] and try again.");
  }

  double get sports {
    throw UnimplementedError("impalement [sports] and try again.");
  }

  double get weightTrainingMuscleGain {
    throw UnimplementedError("impalement [weightTrainingMuscleGain] and try again.");
  }
}

/// `Male`:-
/// - No exercise 0.8 gm
/// - Low-level training 0.9
/// - Active level training 1.2
/// - Sports 1.8
/// - Weight training muscle gain 2.2
class MaleSpecs extends Specs {
  @override
  double get noExercise => .8;

  @override
  double get lowLevelTraining => .9;

  @override
  double get activeLevelTraining => 1.2;

  @override
  double get sports => 1.8;

  @override
  double get weightTrainingMuscleGain => 2.2;
}

/// `Female`:-
/// - No exercise: 0.8 gm
/// - Low-level training: 0.9
/// - Active level training: 1.2
/// - Sports: 1.4
/// - Weight training muscle gain: 1.8
class FemaleSpecs extends Specs {
  @override
  double get noExercise => .8;

  @override
  double get lowLevelTraining => .9;

  @override
  double get activeLevelTraining => 1.2;

  @override
  double get sports => 1.4;

  @override
  double get weightTrainingMuscleGain => 1.8;
}
