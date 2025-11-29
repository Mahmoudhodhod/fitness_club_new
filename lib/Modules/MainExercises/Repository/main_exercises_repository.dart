import '../power_training_module.dart';

class MainExercisesRepository {
  final PowerTaintingApiClient _apiClient;

  MainExercisesRepository({
    required PowerTaintingApiClient client,
  }) : _apiClient = client;

  Future<MainExercisesCategoriesResponse> fetchMainExerciseCategories(
    String token, {
    String? query,
  }) async {
    final result = await _apiClient.fetchMainExerciseCategories(token, query: query);
    return result;
  }

  Future<MainExercisesResponse> fetchMainExercises(
    String token, {
    required int categoryId,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchMainExercises(
      token,
      nextPageUrl: nextPageUrl,
      categoryId: categoryId,
    );
    return result;
  }

  // fetch main exercises by id
  Future<MainExercise> fetchMainExercisesById(
    String token, {
    required int id,
  }) async {
    final result = await _apiClient.fetchMainExercisesById(
      token,
      exerciseId: id,
    );
    return result;
  }

  Future<MainExercisesResponse> searchMainExercises(
    String token, {
    required int categoryId,
    required String query,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchMainExercises(
      token,
      categoryId: categoryId,
      query: query,
      nextPageUrl: nextPageUrl,
    );
    return result;
  }

  Future<MainExercisesResponse> favoriteMainExercises(
    String token, {
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchMainExercises(
      token,
      nextPageUrl: nextPageUrl,
      favorite: true,
    );
    return result;
  }

  Future<PartsResponse> fetchExerciseParts(String token, {required int exerciseID}) async {
    final result = await _apiClient.fetchExerciseParts(
      token,
      exerciseID: exerciseID,
    );
    return result;
  }

  Future<bool> makeMainExerciseFav(String token, {required int exerciseID}) async {
    return _apiClient.makeMainExerciseFav(token, exerciseID: exerciseID);
  }
}
