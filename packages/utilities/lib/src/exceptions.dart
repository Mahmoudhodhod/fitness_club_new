///Descripes and error or and exception thrown
///
class AppException implements Exception {
  ///Exception error message
  ///
  final String? msg;
  const AppException([String? message]) : msg = message;

  @override
  String toString() {
    if (msg == null) return "AppException";
    return "AppException($msg)";
  }
}
