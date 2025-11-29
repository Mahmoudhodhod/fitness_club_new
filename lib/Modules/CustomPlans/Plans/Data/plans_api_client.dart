import 'package:dio/dio.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:utilities/utilities.dart';

import '../../Helpers/helpers.dart';
import '../Models/models.dart';

class CreatingPlanFailure implements Exception {}

class DeletingPlanFailure implements Exception {}

class UpdatingPlanFailure implements Exception {}

class CPlanApiClient {
  final Dio _dio;

  CPlanApiClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<PlansResponse> fetchPlans(String token, {String? nextPageUrl}) async {
    try {
      Uri uri = CustomPlansNetworking.myPlans();
      if (nextPageUrl != null) uri = Uri.parse(nextPageUrl);
      final _response = await _dio.getUri(
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

  Future<Plan> createPlan(String token, {required NewPlan plan}) async {
    try {
      final uri = CustomPlansNetworking.myPlans();
      final _response = await _dio.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: plan.toJson(),
      );
      if (_response.statusCode != 200) throw CreatingPlanFailure();
      final _body = _response.data['plan'];
      return Plan.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<Plan> updatePlan(String token, {required int id, required NewPlan plan}) async {
    try {
      final uri = CustomPlansNetworking.myPlans(id);
      final _response = await _dio.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: mergeMaps([
          plan.toJson(),
          {'_method': 'PUT'}
        ]),
      );
      if (_response.statusCode != 200) throw UpdatingPlanFailure();
      final _body = _response.data['plan'];
      return Plan.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deletePlan(String token, {required int id}) async {
    try {
      final uri = CustomPlansNetworking.myPlans(id);
      final _response = await _dio.deleteUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw DeletingPlanFailure();
      return Future<void>.value();
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
