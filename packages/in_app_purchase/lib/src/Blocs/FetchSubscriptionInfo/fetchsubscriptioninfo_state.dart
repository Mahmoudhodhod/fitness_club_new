part of 'fetchsubscriptioninfo_cubit.dart';

abstract class FetchSubscriptionInfoState extends Equatable {
  const FetchSubscriptionInfoState();

  @override
  List<Object?> get props => [];
}

class FetchSubscriptionInfoInitial extends FetchSubscriptionInfoState {
  const FetchSubscriptionInfoInitial();
}

class FetchSubscriptionInfoInProgress extends FetchSubscriptionInfoState {
  const FetchSubscriptionInfoInProgress();
}

class FreeTrialEndedWithNoSubscription extends FetchSubscriptionInfoState {
  const FreeTrialEndedWithNoSubscription();
}

class StillInFreeTrial extends FetchSubscriptionInfoState {
  final int remainingTimeInSecondes;
  const StillInFreeTrial(this.remainingTimeInSecondes);

  @override
  List<Object?> get props => [remainingTimeInSecondes];
}

class FetchSubscriptionInfoSucceeded extends FetchSubscriptionInfoState {
  final SubscriptionInfo info;
  const FetchSubscriptionInfoSucceeded(this.info);

  @override
  List<Object> get props => [info];
}

//ignore: avoid_implementing_value_types
class FetchSubscriptionInfoFailure extends ErrorState implements FetchSubscriptionInfoState {
  const FetchSubscriptionInfoFailure([Object? e]) : super(e);
}
