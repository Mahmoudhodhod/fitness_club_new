import 'package:flutter/material.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:provider/provider.dart';

const kDefaultTextScale = 1.0;

///Handles font scaling perviewer and changes the app font scale.
///
///User [FontScaleHandler.get(BuildContext)] to return a valid provider instance.
///
class FontScaleHandler extends ChangeNotifier {
  ///Returns a provider instance for the current [ChangeNotifier].
  ///
  static FontScaleHandler get(BuildContext context) => context.read<FontScaleHandler>();

  double? _fontScale;

  ///The current app font scale
  ///
  ///Defaults to `1.0`.
  double get fontScale => _fontScale ?? _getValue() ?? kDefaultTextScale;

  ///Change the app font scale.
  ///
  ///* [scale] must be a double value between 0.5 and 3.
  ///
  Future<void> changeFontScale(double scale) async {
    assert(scale >= 0.5 && scale < 3);
    if (scale == _fontScale) return;
    _fontScale = scale;
    await _saveValue(scale);
    notifyListeners();
  }

  ///Resets the app font scale to the default `1.0`.
  ///
  Future<void> resetToDefault() {
    return changeFontScale(1);
  }

  @visibleForTesting
  static const scaleFactorKey = '__text_scale_factor__';

  Future<void> _saveValue(double value) async {
    await PreferencesUtilities.instance!.saveValueWithKey<double>(scaleFactorKey, value);
  }

  double? _getValue() {
    return PreferencesUtilities.instance!.getValueWithKey<double>(scaleFactorKey, hideDebugPrint: true);
  }
}
