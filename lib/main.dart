import 'dart:developer';
import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/DeepLinking/deep_linking_module.dart';
import 'package:the_coach/Modules/PushNotifications/service.dart';
import 'package:the_coach/Widgets/widgets.dart';

import 'MainUtilities/main_utilities.dart';
import 'app.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'appsflyer_global.dart';

// TODO: add custom logger integration
// https://pub.dev/packages/logger

/*
? Get key SHA1: run `keytool -list -v -keystore debug.jks  -alias debug`
?   keytool -exportcert -alias "key alias" -keystore "path/to/key" | openssl sha1 -binary | openssl base64
?   keytool -exportcert -alias fit -keystore fit.keystore | openssl sha1 -binary | openssl base64
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _appInitializations();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  return runApp(
    Phoenix(
      child: RepositoryProviders(
        child: SetUpEasyLocalization(
          child: const MyApp(),
        ),
      ),
    ),
  );
}

Future<void> _appInitializations() async {
  try {
    PushNotificationService.registerBackgroundService();
    await Firebase.initializeApp();
    await MobileAds.instance.initialize();
    await _initAppsFlyer();

    await EasyLocalization.ensureInitialized();
    await PreferencesUtilities.init();
    await CountryCodes.init();

    Future<void>.microtask(() {
      MediaController.init(AppMediaPicker());
      AppPackageInfo.init();
      Bloc.observer = AppBlocObserver();
      ShareNow.init();
    });
  } catch (e, t) {
    log(e.toString(), stackTrace: t);
    FirebaseCrashlytics.instance.recordError(e, t);
  }
}

Future<void> _initAppsFlyer() async {
  if (Platform.isIOS) {
    appsFlyerGlobal = AppsflyerSdk(
      AppsFlyerOptions(
        afDevKey: "YYcJUMtMcNU2yoM5Eaja8d",
        appId: "id6444704428",
        showDebug: true,
      ),
    );
  } else {
    appsFlyerGlobal = AppsflyerSdk(
      AppsFlyerOptions(
        afDevKey: "YYcJUMtMcNU2yoM5Eaja8d",
        appId: "io.fitness.club",
        showDebug: true,
      ),
    );
  }
  try {
    await appsFlyerGlobal.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appsFlyerGlobal.startSDK();
    // iOS 14+
    // if (Platform.isIOS) {
    //   await appsFlyerGlobal.requestTrackingAuthorization();
    // }
  } catch (e, st) {
    log('AppsFlyer init error: $e', stackTrace: st);
    FirebaseCrashlytics.instance.recordError(e, st);
  }
}
