import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

///Resource [StackoverFlow](https://stackoverflow.com/questions/45300661/how-to-check-the-device-os-version-from-flutter)
extension Version on Platform {
  ///Check if the ios version supplied is the current running.
  Future<bool> isIOSAvailable(double version) async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.systemName.contains(version.toStringAsFixed(1));
  }

  ///Check if the android SDK version supplied is the current running.
  Future<bool> isAndroidSDKAvailable(double version) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt
        .toString()
        .contains(version.toStringAsFixed(1));
  }
}
