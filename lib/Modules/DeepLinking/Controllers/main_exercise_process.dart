import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/power_training_module.dart' show MainExercise, MainExercisesRepository;
import 'package:the_coach/Screens/Tabs/MainExercises/exercise_details.dart' show MainExerciseDetails;

import '../Models/models.dart';
import '_interface.dart';

class MainExerciseProcess extends DeepLinkingProcess<MainExercise> {
  final MainExercisesRepository _repository;

  MainExerciseProcess(this._repository);

  @override
  Future<MainExercise> executeProcess(ApiOptions options) {
    return _repository.fetchMainExercisesById(
      options.accessToken,
      id: options.deepLinkingOptions.id,
    );
  }

  @override
  void onProcessFinished(MainExercise exercise) {
    Navigator.push(
      NavigationService.context!,
      MaterialPageRoute(
        builder: (_) => MainExerciseDetails(exercise: exercise),
      ),
    );
  }
}
