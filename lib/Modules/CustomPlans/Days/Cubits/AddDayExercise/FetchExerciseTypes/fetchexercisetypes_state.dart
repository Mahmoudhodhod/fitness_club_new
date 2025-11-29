part of 'fetchexercisetypes_cubit.dart';

abstract class FetchExerciseTypesState extends Equatable {
  const FetchExerciseTypesState();

  @override
  List<Object?> get props => [];
}

class FetchExerciseTypesInitial extends FetchExerciseTypesState {}

class FetchExerciseTypesInProgress extends FetchExerciseTypesState {}

class FetchExerciseTypesSucceeded extends FetchExerciseTypesState {
  final List<ExerciseType> types;
  FetchExerciseTypesSucceeded(this.types);

  @override
  List<Object?> get props => [types];
}

class FetchExerciseTypesFailed extends ErrorState implements FetchExerciseTypesState {
  const FetchExerciseTypesFailed([Object? e]) : super(e);
}
