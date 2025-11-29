part of 'watchsubscriberinfochange_cubit.dart';

abstract class WatchSubscriberInfoChangeState extends Equatable {
  const WatchSubscriberInfoChangeState();

  @override
  List<Object> get props => [];
}

class WatchSubscriberInfoChangeInitial extends WatchSubscriberInfoChangeState {
  const WatchSubscriberInfoChangeInitial();
}

class SubscriptionInfoChanged extends WatchSubscriberInfoChangeState {
  final SubscriptionInfo info;

  const SubscriptionInfoChanged(this.info);

  bool get isActiveSubscription => info.isActive;

  bool get isSubscriptionExpired => info.isExpired;

  @override
  List<Object> get props => [info];
}
