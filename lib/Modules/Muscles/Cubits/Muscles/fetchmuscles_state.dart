part of 'fetchmuscles_cubit.dart';

abstract class FetchMusclesState extends Equatable {
  const FetchMusclesState();

  @override
  List<Object?> get props => [];
}

class FetchMusclesInitial extends FetchMusclesState {}

class FetchMusclesInProgress extends FetchMusclesState {}

class FetchMusclesSucceeded extends FetchMusclesState {
  final List<Muscle> muscles;

  const FetchMusclesSucceeded({required this.muscles});

  @override
  String toString() => 'FetchMusclesSucceeded(muscles: ${muscles.length})';

  @override
  List<Object?> get props => [muscles];
}

class FetchMusclesFailure extends ErrorState implements FetchMusclesState {
  const FetchMusclesFailure([Object? e]) : super(e);
}
