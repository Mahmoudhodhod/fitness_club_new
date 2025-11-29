part of 'fetchmuscleexercises_cubit.dart';

abstract class FetchMuscleExercisesState extends Equatable {
  const FetchMuscleExercisesState();

  @override
  List<Object?> get props => [];
}

class FetchMuscleExercisesInitial extends FetchMuscleExercisesState {}

class FetchMuscleExercisesInProgress extends FetchMuscleExercisesState {}

class FetchMuscleExercisesSucceeded extends FetchMuscleExercisesState {
  final List<SubExercise> exercises;
  final int? muscleID;

  FetchMuscleExercisesSucceeded({
    required this.exercises,
    this.muscleID = -1,
  });

  @override
  List<Object?> get props => [exercises, muscleID];
}

class FetchMuscleExercisesFailed extends ErrorState implements FetchMuscleExercisesState {
  const FetchMuscleExercisesFailed([Object? e]) : super(e);
}
