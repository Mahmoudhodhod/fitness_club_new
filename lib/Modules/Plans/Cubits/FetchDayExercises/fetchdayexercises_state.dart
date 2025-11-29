part of 'fetchdayexercises_cubit.dart';

abstract class FetchDayExercisesState extends Equatable {
  const FetchDayExercisesState();

  @override
  List<Object?> get props => [];
}

class FetchDayExercisesInitial extends FetchDayExercisesState {}

class FetchDayExercisesInProgress extends FetchDayExercisesState {}

class FetchDayExercisesSucceeded extends FetchDayExercisesState {
  final List<DayExercise> days;

  FetchDayExercisesSucceeded({
    required this.days,
  });

  @override
  List<Object> get props => [days];
}

class FetchDayExercisesFailed extends ErrorState implements FetchDayExercisesState {
  FetchDayExercisesFailed([Object? e]) : super(e);
}
