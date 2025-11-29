part of 'fetchplans_cubit.dart';

extension on FetchedPlansSuccessfully {
  bool get isPaginating => this.paginationState == PaginationState.paginating;
}

abstract class FetchPlansState extends Equatable {
  const FetchPlansState();

  @override
  List<Object?> get props => [];
}

class FetchPlansInitial extends FetchPlansState {}

class FetchPlansInProgress extends FetchPlansState {}

class FetchedPlansSuccessfully extends FetchPlansState {
  final List<Plan> plans;
  final String? nextPageUrl;
  final int? categoryID;
  final PaginationState paginationState;

  const FetchedPlansSuccessfully({
    required this.plans,
    this.nextPageUrl,
    this.categoryID = -1,
    this.paginationState = PaginationState.loaded,
  });

  bool get hasNextPage => nextPageUrl != null;

  @override
  List<Object?> get props => [plans, nextPageUrl, paginationState];

  static FetchedPlansSuccessfully get empty => const FetchedPlansSuccessfully(plans: []);

  FetchedPlansSuccessfully copyWith({
    List<Plan>? plans,
    String? nextPageUrl,
    int? categoryID,
    PaginationState? paginationState,
  }) {
    return FetchedPlansSuccessfully(
      plans: plans ?? this.plans,
      nextPageUrl: nextPageUrl,
      categoryID: categoryID ?? this.categoryID,
      paginationState: paginationState ?? this.paginationState,
    );
  }
}

class FetchPlansFailed extends ErrorState implements FetchPlansState {
  const FetchPlansFailed([Object? e]) : super(e);
}
