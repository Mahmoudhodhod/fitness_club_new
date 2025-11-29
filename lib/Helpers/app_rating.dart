import 'dart:math' as math;

import 'package:in_app_review/in_app_review.dart';
import 'package:preferences_utilities/preferences_utilities.dart';

const _kMinDaysBetween = 1;
const _kMaxDaysBetween = 2;
// const _kMinDaysBetween = 4;
// const _kMaxDaysBetween = 6;
const _kRatedDateKey = '__APP_RATED_DATE__';

/*
Details:
- only show the rating dialog for users older than 5 days
- view dialog once every 4 to 6 days (random)
- if the user already rated the app, show the actual store listing
*/
Future<void> displayAppRating() async {
  final prefs = PreferencesUtilities.instance;
  final _inAppReview = InAppReview.instance;
  final isAvailable = await _inAppReview.isAvailable();
  _inAppReview.requestReview();
  if (!isAvailable) return;
  final now = DateTime.now();
  final ratedDateInMilli = prefs?.getValueWithKey<int>(_kRatedDateKey);
  if (ratedDateInMilli == null) {
    await _saveNextDialogAndRate();
    return;
  }
  final ratedDate = DateTime.fromMillisecondsSinceEpoch(ratedDateInMilli);
  final daysBetween = now.difference(ratedDate).inDays;
  if (daysBetween < _kMinDaysBetween) return;
  await _saveNextDialogAndRate();
}

Future<void> _saveNextDialogAndRate() async {
  final prefs = PreferencesUtilities.instance;
  final _inAppReview = InAppReview.instance;
  final now = DateTime.now();
  final random = math.Random();
  final daysBetween =
      random.nextInt(_kMaxDaysBetween - _kMinDaysBetween) + _kMinDaysBetween;
  final nextDate = now.add(Duration(days: daysBetween));
  await prefs?.saveValueWithKey<int>(
      _kRatedDateKey, nextDate.millisecondsSinceEpoch);
  await _inAppReview.requestReview();
}

Future<void> openRateListing() {
  return InAppReview.instance.openStoreListing(appStoreId: '6444704428');
}
