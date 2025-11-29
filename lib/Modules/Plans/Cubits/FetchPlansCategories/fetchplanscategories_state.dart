part of 'fetchplanscategories_cubit.dart';

abstract class FetchPlansCategoriesState extends Equatable {
  const FetchPlansCategoriesState();

  @override
  List<Object?> get props => [];
}

class FetchPlansCategoriesInitial extends FetchPlansCategoriesState {}

class FetchCategoriesInProgress extends FetchPlansCategoriesState {}

class FetchCategoriesSucceeded extends FetchPlansCategoriesState {
  final List<PlanCategory> categories;
  FetchCategoriesSucceeded({
    required this.categories,
  });

  @override
  List<Object> get props => [categories];
}

class FetchCategoriesFailed extends ErrorState implements FetchPlansCategoriesState {
  const FetchCategoriesFailed([Object? e]) : super(e);
}
