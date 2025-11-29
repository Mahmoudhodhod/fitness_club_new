part of 'fetchmainexercises_cubit.dart';

extension on FetchExercisesSucceeded {
  bool get isPaginating => this.paginationState == PaginationState.paginating;
}

abstract class FetchMainExercisesState extends Equatable {
  const FetchMainExercisesState();

  @override
  List<Object?> get props => [];
}

class FetchMainExercisesInitial extends FetchMainExercisesState {}

class FetchMainExercisesInProgress extends FetchMainExercisesState {}

class FetchExercisesSucceeded extends FetchMainExercisesState {
  final int? categoryId;
  final List<MainExercise> exercises;
  final String? nextPageUrl;
  final PaginationState paginationState;

  const FetchExercisesSucceeded({
    this.categoryId,
    required this.exercises,
    this.nextPageUrl,
    this.paginationState = PaginationState.loaded,
  });

  bool get hasNextPage => nextPageUrl != null;

  @override
  String toString() => 'FetchExercisesSucceeded(exercises: ${exercises.length}, '
      'hasNextPage: $hasNextPage)';

  @override
  List<Object?> get props => [exercises, nextPageUrl, paginationState];

  FetchExercisesSucceeded copyWith({
    int? categoryId,
    List<MainExercise>? exercises,
    String? nextPageUrl,
    PaginationState? paginationState,
  }) {
    return FetchExercisesSucceeded(
      categoryId: categoryId ?? this.categoryId,
      exercises: exercises ?? this.exercises,
      nextPageUrl: nextPageUrl,
      paginationState: paginationState ?? this.paginationState,
    );
  }
}

class FetchMainExercisesFailed extends ErrorState implements FetchMainExercisesState {
  const FetchMainExercisesFailed([Object? e]) : super(e);
}
