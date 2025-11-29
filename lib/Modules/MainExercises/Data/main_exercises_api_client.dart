import 'package:dio/dio.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/Helpers/networking.dart';
import 'package:the_coach/Modules/MainExercises/Models/models.dart';

class FetchingMainExerciseCategoriesFailure implements Exception {}

class FetchingMainExercisesFailure implements Exception {}

class FetchingPartsFailure implements Exception {}

class MakeMainExerciseFavFailure implements Exception {}

class PowerTaintingApiClient {
  final Dio _client;

  PowerTaintingApiClient({Dio? client}) : _client = client ?? Dio();

  Future<MainExercisesCategoriesResponse> fetchMainExerciseCategories(String token, {String? query}) async {
    try {
      final uri = PowerTrainingNetworking.mainExerciseCategories(query: query);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingMainExerciseCategoriesFailure();
      final _body = _response.data;
      return MainExercisesCategoriesResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<MainExercisesResponse> fetchMainExercises(
    String token, {
    int? categoryId,
    String? query,
    bool? favorite,
    String? nextPageUrl,
  }) async {
      Uri uri = PowerTrainingNetworking.mainExercisesUri(
        categoryId: categoryId,
        query: query,
        favorite: favorite,
      );
      if (nextPageUrl != null) uri = Uri.parse(nextPageUrl);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingMainExercisesFailure();
      final _body = _response.data;
      return MainExercisesResponse.fromJson(_body);
  }

  // Fetch main exercises by id
  Future<MainExercise> fetchMainExercisesById(
    String token, {
    required int exerciseId,
  }) async {
    final uri = PowerTrainingNetworking.mainExerciseById(exerciseId);
    final _response = await _client.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    final _body = _response.data;
    return MainExercise.fromJson(_body['main_exercise']);
  }

  Future<PartsResponse> fetchExerciseParts(String token, {required int exerciseID}) async {
    try {
      final uri = PowerTrainingNetworking.exercisePartsUri(exerciseID);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingPartsFailure();
      final _body = _response.data;
      return PartsResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  ///Returns [true] if the current main-exercise is now favorite and vice versa.
  ///
  Future<bool> makeMainExerciseFav(String token, {required int exerciseID}) async {
    try {
      final uri = Network.favoriteUri;
      final _response = await _client.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: PostAction.mainExercise(modelID: exerciseID).toJson(),
      );
      if (_response.statusCode != 200) throw MakeMainExerciseFavFailure();
      return _response.data['message'] == "create";
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
