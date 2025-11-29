import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/src/Utilities/exceptions.dart';
import 'package:utilities/utilities.dart';

part 'fetchsubscriptionstatus_state.dart';

class FetchSubscriptionStatusCubit extends Cubit<FetchSubscriptionStatusState> {
  final IAPController _iapController;

  FetchSubscriptionStatusCubit({
    required IAPController controller,
  })  : _iapController = controller,
        super(const FetchSubscriptionStatusInitial());

  Future<void> fetchSubscriptionStatus() async {
    emit(const FetchSubscriptionStatusInProgress());
    try {
      final subscription = await _iapController.fetchPurchaserInfo();
      _handleSubscriptionInfo(subscription);
    } on SubscriberIsAdmin {
      /* do nothing */
      return emit(const FetchSubscriptionStatusInitial());
    } catch (e, stacktrace) {
      logger.e('', e, stacktrace);
      emit(FetchSubscriptionStatusFailure(e));
    }
  }

  void _handleSubscriptionInfo(SubscriptionInfo? subscription) {
    if (subscription == null) {
      emit(const FetchSubscriptionStatusResultedNeverSubscribed());
    } else if (subscription.isExpired) {
      emit(const FetchSubscriptionStatusResultedExpiration());
    }
  }
}
