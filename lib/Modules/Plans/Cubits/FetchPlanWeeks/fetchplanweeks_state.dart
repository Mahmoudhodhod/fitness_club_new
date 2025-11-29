part of 'fetchplanweeks_cubit.dart';

abstract class FetchPlanWeeksState extends Equatable {
  const FetchPlanWeeksState();

  @override
  List<Object?> get props => [];
}

class FetchPlanWeeksInitial extends FetchPlanWeeksState {}

class FetchPlanWeeksInProgress extends FetchPlanWeeksState {}

class FetchPlanWeeksSucceeded extends FetchPlanWeeksState {
  final List<PlanWeek> weeks;
  FetchPlanWeeksSucceeded({
    required this.weeks,
  });

  @override
  List<Object> get props => [weeks];
}

class FetchPlanWeeksFailed extends ErrorState implements FetchPlanWeeksState {
  FetchPlanWeeksFailed([Object? e]) : super(e);
}
