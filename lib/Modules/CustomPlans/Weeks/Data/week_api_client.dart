import 'package:dio/dio.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:utilities/utilities.dart';

import '../../Helpers/helpers.dart';

class CreatingPlanWeekFailure implements Exception {}

class DeletingPlanWeekFailure implements Exception {}

class CPlanWeekApiClient {
  final Dio _dio;

  CPlanWeekApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<PlanWeeksResponse> fetchPlanWeeks(String token, {required int planID}) async {
    try {
      final uri = CustomPlansNetworking.planWeeks(planID);
      final _response = await _dio.getUri(
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

  Future<PlanWeek> createWeek(String token, {required int planID}) async {
    try {
      final uri = CustomPlansNetworking.planWeeks(planID);
      final _response = await _dio.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw CreatingPlanWeekFailure();
      final _body = _response.data['plan_week'];
      return PlanWeek.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteWeek(String token, {required int planID, required int id}) async {
    try {
      final uri = CustomPlansNetworking.planWeeks(planID, id);
      final _response = await _dio.deleteUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw DeletingPlanWeekFailure();
      return Future<void>.value();
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
