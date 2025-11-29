import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Settings/settings.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

void launchPrivacyPolicy() {
  final settings = _getSettings();
  final url = settings?.privacyPolicy;
  if (url == null) {
    CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr()).showWithoutContext();
    return;
  }
  launchUri(url.toString());
}

void launchTermsOfService() {
  final settings = _getSettings();
  final url = settings?.termsAndConditions;
  if (url == null) {
    CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr()).showWithoutContext();
    return;
  }
  launchUri(url.toString());
}

void openISSACert() async {
  final uri = Uri.parse("https://el-captain.net/storage/certs/issa_certificate.pdf");
  await url_launcher.launchUrl(uri);
}

AppSettings? _getSettings() {
  final context = NavigationService.context!;
  var state = context.read<FetchAppSettingsCubit>().state;
  if (state.status != FetchAppSettingsStatus.loaded) {
    log("Settings not loaded");
    CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr()).show(context);
    return null;
  }
  return state.settings;
}

///Returns the current app id of the app which was supplied in the dashboard.
///otherwise returns [null].
///
String? currentAppID([BuildContext? context]) {
  throw UnimplementedError("implement currentAppID()");
}

Interceptor languageInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      final context = NavigationService.context!;
      final language = EasyLocalization.of(context)?.locale.languageCode ?? 'ar';
      options.headers["Accept-Language"] = language;
      handler.next(options);
    },
  );
}
