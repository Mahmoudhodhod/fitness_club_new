import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode mode = ThemeMode.dark;
  Brightness? _systemBrightness;

  static const _themeKey = '__THEME_KEY__';

  ThemeNotifier() {
    final int? val = PreferencesUtilities.instance!.getValueWithKey<int?>(_themeKey);
    final int index = val ?? ThemeMode.dark.index;
    mode = ThemeMode.values[index];
    Future.delayed(Duration(milliseconds: 500), notifyListeners);
  }

  bool get isDarkMode {
    if (_systemBrightness != null && mode == ThemeMode.system) {
      return _systemBrightness == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }

  void switchSystemBrightness(Brightness brightness) {
    _systemBrightness = brightness;
    notifyListeners();
  }

  void switchTheme(ThemeMode mode) {
    this.mode = mode;
    _save(mode);
    notifyListeners();
  }

  void _save(ThemeMode mode) async {
    await PreferencesUtilities.instance!.saveValueWithKey<int>(_themeKey, mode.index);
  }

  @override
  void dispose() {
    print("ThemeNotifier dispose\t"+DateTime.now().toIso8601String());
    
    super.dispose();
  }
}

extension Localize on ThemeMode {
  String localized() {
    switch (this) {
      case ThemeMode.system:
        return LocaleKeys.drawer_settings_theme_system.tr();
      case ThemeMode.light:
        return LocaleKeys.drawer_settings_theme_light.tr();
      case ThemeMode.dark:
        return LocaleKeys.drawer_settings_theme_dark.tr();
    }
  }
}
