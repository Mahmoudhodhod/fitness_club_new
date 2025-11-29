part of 'fetchmusclesubexercises_cubit.dart';

extension on FetchExercisesSucceeded {
  bool get isPaginating => this.paginationState == PaginationState.paginating;
}

abstract class FetchSubExercisesState extends Equatable {
  const FetchSubExercisesState();

  @override
  List<Object?> get props => [];
}

class FetchExercisesInitial extends FetchSubExercisesState {}

class FetchExercisesInProgress extends FetchSubExercisesState {}

class FetchExercisesSucceeded extends FetchSubExercisesState {
  final List<SubExercise> exercises;
  final String? nextPageUrl;
  final int? muscleID;
  final PaginationState paginationState;

  const FetchExercisesSucceeded({
    required this.exercises,
    this.nextPageUrl,
    this.muscleID = -1,
    this.paginationState = PaginationState.loaded,
  });

  bool get hasNextPage => nextPageUrl != null;

  @override
  String toString() => '''FetchSubExercisesSucceeded(exercises: ${exercises.length}, 
                                    hasNextPage: $hasNextPage, 
                                    muscleID: $muscleID)''';

  FetchExercisesSucceeded copyWith({
    List<SubExercise>? exercises,
    String? nextPageUrl,
    int? muscleID,
    PaginationState? paginationState,
  }) {
    return FetchExercisesSucceeded(
      exercises: exercises ?? this.exercises,
      nextPageUrl: nextPageUrl,
      muscleID: muscleID ?? this.muscleID,
      paginationState: paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object?> get props => [
        exercises,
        nextPageUrl,
        muscleID,
        paginationState,
      ];
}

class FetchExercisesFailure extends ErrorState implements FetchSubExercisesState {
  const FetchExercisesFailure([Object? e]) : super(e);
}
