part of 'buyoffering_cubit.dart';

abstract class BuyOfferingState extends Equatable {
  const BuyOfferingState();

  @override
  List<Object?> get props => [];
}

class BuyOfferingInitial extends BuyOfferingState {
  const BuyOfferingInitial();
}

class BuyOfferingInProgress extends BuyOfferingState {
  const BuyOfferingInProgress();
}

class BuyOfferingSucceeded extends BuyOfferingState {
  final String userId;
  final PackageType packageName;
  const BuyOfferingSucceeded({
    required this.userId,
    required this.packageName,
  });
}

//ignore: avoid_implementing_value_types
class BuyOfferingFailure extends ErrorState implements BuyOfferingState {
  const BuyOfferingFailure([Object? e]) : super(e);
}
