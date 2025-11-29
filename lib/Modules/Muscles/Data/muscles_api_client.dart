import 'package:dio/dio.dart';
import 'package:the_coach/Helpers/logger.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:utilities/utilities.dart';

class FetchingMusclesFailure implements Exception {}

class FetchingSubExercisesFailure implements Exception {}

class MakeSubExerciseFavFailure implements Exception {}

class MusclesApiClient {
  final Dio _client;

  ///Creates Muscles client to handle api calls and responses.
  ///
  MusclesApiClient({Dio? client}) : _client = client ?? Dio();

  Future<MusclesResponse> fetchMuscles(String token) async {
    try {
      final uri = MusclesNetworking.musclesUri;
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingMusclesFailure();
      final _body = _response.data;
      return MusclesResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<SubExercisesResponse> fetchSubExercises(
    String token, {
    int? muscleID,
    String? query,
    String? nextPageUrl,
  }) async {
    Uri uri = MusclesNetworking.musclesSubExercisesUri(muscleID, query);
    if (nextPageUrl != null) uri = Uri.parse(nextPageUrl);
    appLogger.d(uri.toString());
    final _response = await _client.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    if (_response.statusCode != 200) throw FetchingSubExercisesFailure();
    final _body = _response.data;
    return SubExercisesResponse.fromJson(_body);
  }

  // Fetch sub exercise with id
  Future<SubExercise> fetchSubExercise(
    String token, {
    required int id,
  }) async {
    final uri = MusclesNetworking.subExerciseByIdUri(id);
    final _response = await _client.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    final _body = _response.data;
    return SubExercise.fromJson(_body['sub_exercise']);
  }

  ///Returns [true] if the current sub-exercise is now favorite and vice versa.
  ///
  Future<bool> makeSubExerciseFav(String token, {required int subExerciseID}) async {
    try {
      final uri = Network.favoriteUri;
      final _response = await _client.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: PostAction.subExercise(modelID: subExerciseID).toJson(),
      );
      if (_response.statusCode != 200) throw MakeSubExerciseFavFailure();
      return _response.data['message'] == "create";
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
