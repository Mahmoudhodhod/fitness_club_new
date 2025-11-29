part of 'fetch_packages_cubit.dart';

abstract class FetchPackagesState extends Equatable {
  const FetchPackagesState();

  @override
  List<Object?> get props => [];
}

class FetchPackagesInitial extends FetchPackagesState {
  const FetchPackagesInitial();
}

class FetchPackagesInProgress extends FetchPackagesState {
  const FetchPackagesInProgress();
}

class FetchPackagesSucceeded extends FetchPackagesState {
  final List<Package> packages;
  const FetchPackagesSucceeded(this.packages);

  @override
  List<Object> get props => [packages];
}

//ignore: avoid_implementing_value_types
class FetchPackagesFialure extends ErrorState implements FetchPackagesState {
  const FetchPackagesFialure([Object? e]) : super(e);
}
