import 'dart:developer';

import 'package:dio/dio.dart';

///Returns string presents [Exceptions] to a human readable form.
///
String errorLogStr(Object? e) {
  if (e == null) return "NULL ERROR";

  if (e is DioError) {
    return '''
Message: ${e.response?.data["message"] ?? e.response},
StatusCode: ${e.response?.statusCode},
StatusMessage: ${e.response?.statusMessage},
Type: ${e.type},
Errors: ${e.response?.data["errors"] ?? e.response}
''';
  }

  return e.toString();
}

///Logs the current error to the screen.
///
void logError(Object? e) {
  return log(errorLogStr(e));
}
