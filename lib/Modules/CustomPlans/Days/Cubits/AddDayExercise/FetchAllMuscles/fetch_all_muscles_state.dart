part of 'fetch_all_muscles_cubit.dart';

abstract class FetchAllMusclesState extends Equatable {
  const FetchAllMusclesState();

  @override
  List<Object?> get props => [];
}

class FetchAllMusclesInitial extends FetchAllMusclesState {}

class FetchAllMusclesInProgress extends FetchAllMusclesState {}

class FetchAllMusclesSucceeded extends FetchAllMusclesState {
  final List<Muscle> muscles;

  FetchAllMusclesSucceeded({required this.muscles});

  @override
  List<Object?> get props => [muscles];
}

class FetchAllMusclesFailed extends ErrorState implements FetchAllMusclesState {
  const FetchAllMusclesFailed([Object? e]) : super(e);
}
