import 'package:the_coach/Modules/Muscles/muscles_module.dart';

class MusclesRepository {
  final MusclesApiClient _apiClient;

  MusclesRepository({
    required MusclesApiClient client,
  }) : _apiClient = client;

  Future<MusclesResponse> fetchMuscles(String token) async {
    final result = await _apiClient.fetchMuscles(token);
    return result;
  }

  Future<SubExercisesResponse> fetchSubExercises(
    String token, {
    required int muscleID,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchSubExercises(
      token,
      muscleID: muscleID,
      nextPageUrl: nextPageUrl,
    );
    return result;
  }

  // Fetch sub exercise with id
  Future<SubExercise> fetchSubExerciseById(
    String token, {
    required int id,
  }) async {
    final result = await _apiClient.fetchSubExercise(
      token,
      id: id,
    );
    return result;
  }

  Future<SubExercisesResponse> searchSubExercises(
    String token, {
    required String query,
    required int muscleID,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchSubExercises(
      token,
      query: query,
      nextPageUrl: nextPageUrl,
      muscleID: muscleID,
    );
    return result;
  }

  Future<bool> makeSubExerciseFav(String token, {required int exerciseID}) async {
    return await _apiClient.makeSubExerciseFav(token, subExerciseID: exerciseID);
  }
}
