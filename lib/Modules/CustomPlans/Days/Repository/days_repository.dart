import 'package:the_coach/Modules/CustomPlans/Days/Data/api_clients.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

import '../Models/models.dart';

class CDaysRepository {
  final CustomDayExerciseApiClient _client;

  CDaysRepository({required CustomDayExerciseApiClient client}) : _client = client;

  Future<DayExercisesResponse> fetchDayExercises(
    String token, {
    required int dayID,
  }) async {
    return _client.fetchDayExercises(token, dayID: dayID);
  }

  Future<DayExercise> createExercise(
    String token, {
    required int dayID,
    required NewDayExercise exercise,
  }) async {
    return _client.createExercise(
      token,
      dayID: dayID,
      exercise: exercise,
    );
  }

  Future<DayExercise> updateExercise(
    String token, {
    required int dayID,
    required int exerciseID,
    required NewDayExercise plan,
  }) async {
    return _client.updateExercise(token, dayID: dayID, exerciseID: exerciseID, plan: plan);
  }

  Future<void> deleteExercise(
    String token, {
    required int dayID,
    required int exerciseID,
  }) async {
    return _client.deleteExercise(token, dayID: dayID, exerciseID: exerciseID);
  }
}
