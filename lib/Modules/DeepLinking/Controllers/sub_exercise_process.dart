import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart' show MusclesRepository, SubExercise;
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart' show MuscleExerciseDetails;

import '../Models/models.dart';
import '_interface.dart';

class SubExerciseProcess extends DeepLinkingProcess<SubExercise> {
  final MusclesRepository _repository;

  SubExerciseProcess(this._repository);

  @override
  Future<SubExercise> executeProcess(ApiOptions options) {
    return _repository.fetchSubExerciseById(
      options.accessToken,
      id: options.deepLinkingOptions.id,
    );
  }

  @override
  void onProcessFinished(SubExercise exercise) {
    Navigator.push(
      NavigationService.context!,
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: exercise),
      ),
    );
  }
}
