import 'package:package_info_plus/package_info_plus.dart';

//TODO: document
class AppPackageInfo {
  AppPackageInfo._();
  static PackageInfo? _packageInfo;

  static AppPackageInfo? _instance;

  AppPackageInfo.init() {
    _init();
  }

  Future<void> _init() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
  }

  factory AppPackageInfo.instance() {
    _instance ??= AppPackageInfo._();
    return _instance!;
  }

  String bundleID() {
    assert(_instance != null);
    assert(_packageInfo != null,
        "Did you forget to call [Package.init()] in main?");
    return _packageInfo!.packageName;
  }

  String appVersion() {
    assert(_instance != null);
    assert(_packageInfo != null,
        "Did you forget to call [Package.init()] in main?");

    return "${_packageInfo!.version}+${_packageInfo!.buildNumber}";
  }
}
