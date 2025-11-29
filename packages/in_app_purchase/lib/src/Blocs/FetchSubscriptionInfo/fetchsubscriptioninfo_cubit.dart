import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:utilities/utilities.dart' hide logger;

part 'fetchsubscriptioninfo_state.dart';

class FetchSubscriptionInfoCubit extends Cubit<FetchSubscriptionInfoState> {
  final IAPController _iapController;
  FetchSubscriptionInfoCubit({
    required IAPController controller,
  })  : _iapController = controller,
        super(const FetchSubscriptionInfoInitial());

  Future<bool> ifUserSubscription() async {
    final subscription = await _iapController.fetchPurchaserInfo();
    if (subscription == null) {
      final isTrialEnded = await _iapController.isUserFreeTrialEnded();
      if (isTrialEnded) {
        return false;
      }
      final int remainingSeconds =
          await _iapController.freeTrialRemainingTimeInSeconds();
      return true;
    }
    if (subscription.isExpired) {
      return false;
    }
    return true;
  }

  Future<void> fetchSubscriptionInfo() async {
    emit(const FetchSubscriptionInfoInProgress());
    try {
      logger.d('subscriptionsubscription ');

      final subscription = await _iapController.fetchPurchaserInfo();
      if (subscription == null) {
        return _userIsNotSubscribed();
      }
      if (subscription.isExpired) {
        return emit(const FreeTrialEndedWithNoSubscription());
      }
      emit(FetchSubscriptionInfoSucceeded(subscription));
    } catch (e, stacktrace) {
      logger.e(e, e, stacktrace);
      emit(FetchSubscriptionInfoFailure(e));
    }
  }

  Future<void> _userIsNotSubscribed() async {
    final isTrialEnded = await _iapController.isUserFreeTrialEnded();
    if (isTrialEnded) {
      return emit(const FreeTrialEndedWithNoSubscription());
    }
    final int remainingSeconds =
        await _iapController.freeTrialRemainingTimeInSeconds();
    return emit(StillInFreeTrial(remainingSeconds));
  }
}
