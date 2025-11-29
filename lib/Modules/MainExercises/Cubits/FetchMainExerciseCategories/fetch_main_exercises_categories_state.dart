part of 'fetch_main_exercises_categories_cubit.dart';

abstract class FetchMainExerciseCategoriesState extends Equatable {
  const FetchMainExerciseCategoriesState();

  @override
  List<Object?> get props => [];
}

class FetchMainExerciseCategoriesInitial extends FetchMainExerciseCategoriesState {}

class FetchMainExerciseCategoriesInProgress extends FetchMainExerciseCategoriesState {}

class FetchMainExerciseCategoriesSucceeded extends FetchMainExerciseCategoriesState {
  final List<MainExercisesCategory> categories;

  const FetchMainExerciseCategoriesSucceeded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class FetchMainExerciseCategoriesFailed extends ErrorState implements FetchMainExerciseCategoriesState {
  const FetchMainExerciseCategoriesFailed([Object? e]) : super(e);
}
