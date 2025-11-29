import 'dart:developer';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/src/Utilities/exceptions.dart';
import 'package:in_app_purchase/src/logger.dart';

const TRIAL_PERIOD_IN_DAYS = 7;

typedef FetchCurrentSubscriber = Future<Subscriber> Function();

//TODO: handle unexpected errors
class UserSubscriptionInfo {
  Subscriber? _subscriber;
  FetchCurrentSubscriber? _fetchCurrentSubscriber;

  UserSubscriptionInfo();

  set getSubscriber(FetchCurrentSubscriber fetchCurrentSubscriber) {
    _fetchCurrentSubscriber = fetchCurrentSubscriber;
  }

  Future<bool> isSubscribeAnAdmin() async {
    final sub = await _updateCurrentUser();
    return sub.isAdmin;
  }

  Future<bool> isUserFreeTrialEnded() async {
    await _updateCurrentUser();
    if (_subscriber!.isAdmin) {
      throw const SubscriberIsAdmin();
    }
    return _subscriber!.isRegisteredForMoreThan(TRIAL_PERIOD_IN_DAYS);
  }

  Future<int> freeTrialRemainingTimeInSeconds() async {
    final isFreeTrialEnded = await isUserFreeTrialEnded();
    if (isFreeTrialEnded) throw const FreeTrialEndedFailure();
    return _subscriber!.remainingFreeTrialInSeconds(TRIAL_PERIOD_IN_DAYS);
  }

  Future<Subscriber> _updateCurrentUser() async {
    final sub = await _fetchCurrentUserInfo();
    _subscriber = sub;
    return sub;
  }

  Future<Subscriber> _fetchCurrentUserInfo() async {
    assert(
      _fetchCurrentSubscriber != null,
      "Did you forget to call [set getSubscriber()]?",
    );
    try {
      final subscriber = await _fetchCurrentSubscriber!.call();
      log('_fetchCurrentUserInfo_fetchCurrentUserInfo $subscriber');

      return subscriber;
    } catch (e, stacktrace) {
      logger.e('', e, stacktrace);
      throw const FetchingCurrentSubscriberInfoFailure();
    }
  }
}

extension on Subscriber {
  bool isRegisteredForMoreThan(int days) {
    final dateAfterNDaysFromRegistration = _freeTrialExpirationDate(days);

    final currentDate = DateTime.now();
    final isMoreThan = currentDate.isAfter(dateAfterNDaysFromRegistration);
    return isMoreThan;
  }

  int remainingFreeTrialInSeconds(int days) {
    final dateAfterNDaysFromRegistration = _freeTrialExpirationDate(days);
    final currentDate = DateTime.now();
    final diffInMilliseconds =
        dateAfterNDaysFromRegistration.millisecondsSinceEpoch -
            currentDate.millisecondsSinceEpoch;
    assert(!diffInMilliseconds.isNegative);
    return diffInMilliseconds ~/ 1000;
  }

  DateTime _freeTrialExpirationDate(int days) {
    return registeredAt.add(Duration(days: days));
  }
}
