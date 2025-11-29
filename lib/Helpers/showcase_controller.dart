import 'package:preferences_utilities/preferences_utilities.dart';

const _kDefaultShowcaseCount = 1;

class ShowcaseController {
  const ShowcaseController._();
  static ShowcaseController _instance = const ShowcaseController._();
  factory ShowcaseController() => _instance;

  Future<void> shouldDisplay(String key, void Function() display) async {
    final prefs = PreferencesUtilities.instance;
    if (prefs == null) return;
    final showcaseCount = prefs.getValueWithKey(key) ?? 0;
    if (showcaseCount < _kDefaultShowcaseCount) {
      await prefs.saveValueWithKey(key, _kDefaultShowcaseCount);
      display();
      return;
    }
  }

  Future<void> resetShowcase(String key) async {
    final prefs = PreferencesUtilities.instance;
    if (prefs == null) return;
    await prefs.removeValueWithKey(key);
  }
}
