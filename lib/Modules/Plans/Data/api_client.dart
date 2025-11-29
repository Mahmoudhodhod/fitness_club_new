import 'package:dio/dio.dart';
import 'package:utilities/utilities.dart';

import '../plans_module.dart';

class FetchingCategoriesFailure implements Exception {}

class FetchingPlansFailure implements Exception {}

class FetchingPlanWeeksFailure implements Exception {}

class FetchingDayDetailsFailure implements Exception {}

class PlansApiClient {
  final Dio _client;

  PlansApiClient({Dio? client}) : _client = client ?? Dio();

  Future<PlanCategoriesResponse> fetchPlanCategories(String token) async {
    try {
      final uri = PlansNetworking.planCategories;
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingCategoriesFailure();
      final _body = _response.data;
      return PlanCategoriesResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<PlansResponse> fetchPlans(
    String token, {
    String? search,
    int? categoryID,
    String? nextPageUrl,
  }) async {
    try {
      Uri uri = PlansNetworking.plan(query: search, categoryID: categoryID.toString());
      if (nextPageUrl != null) uri = Uri.parse(nextPageUrl);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingPlansFailure();
      final _body = _response.data;
      return PlansResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<PlanWeeksResponse> fetchPlanWeeks(String token, {required int planID}) async {
    try {
      Uri uri = PlansNetworking.planWeeks(planID);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingPlanWeeksFailure();
      final _body = _response.data;
      return PlanWeeksResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<DayExercisesResponse> fetchDayDetails(String token, {required int dayID}) async {
    try {
      Uri uri = PlansNetworking.dayExercise(dayID);
      final _response = await _client.getUri(
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
}
