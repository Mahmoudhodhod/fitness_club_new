import 'dart:developer';

import 'package:country_codes/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Widgets/helpers/MediaController/media_controller.dart';

extension ChangeLang on BuildContext {
  static const _langChangeKey = '__LANG_CHANGE_KEY__';

  Future<void> initLocalization() async {
    final _langChange =
        PreferencesUtilities.instance?.getValueWithKey<bool>(_langChangeKey) ??
            false;
    if (_langChange) return;
    final currentLocale = locale;
    final deviceLocale = CountryCodes.getDeviceLocale() ?? currentLocale;
    late Locale _locale;
    if (deviceLocale == currentLocale) return;
    switch (deviceLocale.languageCode) {
      case "ar":
      case "en":
        _locale = Locale(deviceLocale.languageCode);
        break;
      default:
        _locale = Locale(currentLocale.languageCode);
    }
    log("Device locale: $deviceLocale - Current Locale: $currentLocale - Config Locale: $_locale");
    await setLocale(_locale);
  }

  ///Change the current language of the app.
  ///
  ///Changes [EasyLocalization] and [MediaController] language.
  ///
  Future<void> changeLang(Locale locale) async {
    await setLocale(locale);
    await WidgetsBinding.instance.reassembleApplication();

    final _localization =
        locale.isArabic ? ArabicPickerLocale() : EnglishPickerLocale();
    MediaController.instance.localization = _localization;

    PreferencesUtilities.instance?.saveValueWithKey<bool>(_langChangeKey, true);
  }
}

// Converts Arabic numbers if exits to Latin
String cnvArabicNums(String input) {
  final _arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];
  final _latinNumbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  for (var i = 0; i < _arabicNumbers.length; i++) {
    input = input.replaceAll(_arabicNumbers[i], _latinNumbers[i]);
  }
  return input;
}
