part of 'fetchsubscriptionstatus_cubit.dart';

abstract class FetchSubscriptionStatusState extends Equatable {
  const FetchSubscriptionStatusState();

  @override
  List<Object?> get props => [];
}

class FetchSubscriptionStatusInitial extends FetchSubscriptionStatusState {
  const FetchSubscriptionStatusInitial();
}

class FetchSubscriptionStatusInProgress extends FetchSubscriptionStatusState {
  const FetchSubscriptionStatusInProgress();
}

class FetchSubscriptionStatusResultedNeverSubscribed extends FetchSubscriptionStatusState {
  const FetchSubscriptionStatusResultedNeverSubscribed();
}

class FetchSubscriptionStatusResultedExpiration extends FetchSubscriptionStatusState {
  const FetchSubscriptionStatusResultedExpiration();
}

class FetchSubscriptionStatusFailure extends ErrorState implements FetchSubscriptionStatusState {
  const FetchSubscriptionStatusFailure([Object? e]) : super(e);
}
