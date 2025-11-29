part of 'display_subscription_remider_view_cubit.dart';

abstract class DisplaySubscriptionRemiderViewState extends Equatable {
  const DisplaySubscriptionRemiderViewState();

  @override
  List<Object?> get props => [];
}

class DisplayDialogInitial extends DisplaySubscriptionRemiderViewState {
  const DisplayDialogInitial();
}

class DisplayTrailReminderView extends DisplaySubscriptionRemiderViewState {
  final int remainingTimeInSecondes;

  const DisplayTrailReminderView({
    required this.remainingTimeInSecondes,
  });

  @override
  List<Object> get props => [remainingTimeInSecondes];

  DisplayTrailReminderView copyWith({
    int? remainingTimeInSecondes,
  }) {
    return DisplayTrailReminderView(
      remainingTimeInSecondes: remainingTimeInSecondes ?? this.remainingTimeInSecondes,
    );
  }
}

class DisplayTrialEndView extends DisplaySubscriptionRemiderViewState {
  const DisplayTrialEndView();
}

//ignore: avoid_implementing_value_types
class DisplayDialogFailure extends ErrorState implements DisplaySubscriptionRemiderViewState {
  const DisplayDialogFailure([Object? e]) : super(e);
}
