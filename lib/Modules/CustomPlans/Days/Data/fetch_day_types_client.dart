import 'package:dio/dio.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:utilities/utilities.dart' show commonOptionsWithAuthHeader;

import '../../Helpers/helpers.dart';

class ExerciseTypesClient {
  final Dio _dio;

  ExerciseTypesClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<ExerciseType>> fetchExerciseTypes(String token) async {
    final uri = CustomPlansNetworking.exerciseTypes();
    final _response = await _dio.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    if (_response.statusCode != 200) throw FetchingDayDetailsFailure();
    final _body = _response.data;
    return ExerciseTypesResponse.fromJson(_body).types;
  }
}
