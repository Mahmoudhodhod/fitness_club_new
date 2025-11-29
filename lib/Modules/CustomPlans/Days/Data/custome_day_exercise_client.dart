import 'package:dio/dio.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:utilities/utilities.dart' show commonOptionsWithAuthHeader, mergeMaps;

import '../../Helpers/helpers.dart';
import '../Models/models.dart';

class FetchingDayDetailsFailure implements Exception {}

class CreatingExerciseFailure implements Exception {}

class DeletingExerciseFailure implements Exception {}

class UpdatingExerciseFailure implements Exception {}

enum DayExerciseDirection { desc, asc }

class CustomDayExerciseApiClient {
  final Dio _dio;

  CustomDayExerciseApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<DayExercisesResponse> fetchDayExercises(
    String token, {
    required int dayID,
    DayExerciseDirection direction = DayExerciseDirection.asc,
  }) async {
    try {
      final uri = CustomPlansNetworking.dayExercises(
        dayID,
        direction: direction,
      );
      final _response = await _dio.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingDayDetailsFailure();
      final _body = _response.data;
      return DayExercisesResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<DayExercise> createExercise(
    String token, {
    required int dayID,
    required NewDayExercise exercise,
  }) async {
    try {
      final uri = CustomPlansNetworking.dayExercises(dayID);
      var data = exercise.toJson();
      final _response = await _dio.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: data,
      );
      if (_response.statusCode != 200) throw CreatingExerciseFailure();
      final _body = _response.data['day_exercise'];
      return DayExercise.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<DayExercise> updateExercise(
    String token, {
    required int dayID,
    required int exerciseID,
    required NewDayExercise plan,
  }) async {
    try {
      final uri = CustomPlansNetworking.dayExercises(dayID, exerciseID: exerciseID);
      final _response = await _dio.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: mergeMaps([
          plan.toJson(),
          {'_method': 'PUT'}
        ]),
      );
      if (_response.statusCode != 200) throw UpdatingExerciseFailure();
      final _body = _response.data['day_exercise'];
      return DayExercise.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteExercise(
    String token, {
    required int dayID,
    required int exerciseID,
  }) async {
    try {
      final uri = CustomPlansNetworking.dayExercises(dayID, exerciseID: exerciseID);
      final _response = await _dio.deleteUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw DeletingExerciseFailure();
      return Future<void>.value();
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
