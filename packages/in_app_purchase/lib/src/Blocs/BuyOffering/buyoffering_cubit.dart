import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:utilities/utilities.dart' hide logger;

part 'buyoffering_state.dart';

class BuyOfferingCubit extends Cubit<BuyOfferingState> {
  final IAPController _iapController;
  final FetchSubscriptionInfoCubit _subscriptionInfoCubit;

  BuyOfferingCubit({
    required IAPController controller,
    required FetchSubscriptionInfoCubit subscriptionInfoCubit,
  })  : _iapController = controller,
        _subscriptionInfoCubit = subscriptionInfoCubit,
        super(const BuyOfferingInitial());

  Future<void> buyOffering(Package package) async {
    emit(const BuyOfferingInProgress());
    try {
      final info = await _iapController.makePurchase(package);

      if (info != null) {
        _subscriptionInfoCubit.fetchSubscriptionInfo();
        return emit(BuyOfferingSucceeded(
            packageName: package.packageType, userId: info.originalAppUserId));
      }
      emit(const BuyOfferingInitial());
    } catch (e, stacktrace) {
      logger.e(e, e, stacktrace);
      emit(BuyOfferingFailure(e));
    }
  }
}

extension ExtraBuyOfferingState on BuyOfferingState {
  bool get isInitial => this is BuyOfferingInitial;
  bool get isInProgress => this is BuyOfferingInProgress;
  bool get isSucceeded => this is BuyOfferingSucceeded;
  bool get isFailure => this is BuyOfferingFailure;
}
