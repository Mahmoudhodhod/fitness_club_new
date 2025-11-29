import 'package:logger/logger.dart';

final logger = Logger();

/// Change yhe current logging level of the app.
///
/// All logs with levels below this level will be omitted.
void changeLogLevel(Level level) {
  Logger.level = level;
}
