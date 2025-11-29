import 'package:dio/dio.dart';
import 'package:utilities/utilities.dart';

import 'settings_model.dart';
import '_settings_networking.dart';

class SettingsRepository {
  final Dio _dio;
  SettingsRepository(this._dio);

  Future<AppSettings> fetchSettings() async {
    final response = await _dio.getUri(
      settingUri,
      options: commonOptions(),
    );
    return AppSettings.fromJson(response.data['setting']);
  }
}
