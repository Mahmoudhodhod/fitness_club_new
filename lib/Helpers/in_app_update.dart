import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

Future<void> checkNewVersionUpdate() async {
  if (kDebugMode || Platform.isIOS) return;
  final result = await InAppUpdate.checkForUpdate();

  if (result.updateAvailability == UpdateAvailability.updateAvailable &&
      result.flexibleUpdateAllowed) {
    final flexibleResult = await InAppUpdate.startFlexibleUpdate();
    if (flexibleResult == AppUpdateResult.success) {
      await InAppUpdate.completeFlexibleUpdate();
    }
  }
}