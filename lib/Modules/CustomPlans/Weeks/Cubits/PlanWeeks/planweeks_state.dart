part of 'planweeks_cubit.dart';

///Custom Weeks State, changes when `GET` plans, update and delete.
///
enum CWeeksState {
  initial,

  loading,

  ///General loading, called when you need to ONLY show a progress indicator
  ///spacific to one process, ex: when you create new plan.
  gLoading,

  //General failure state
  gFaliure,

  ///Triggered when  weeks were fetched.
  fetched,

  ///Triggered when a new week was created.
  created,

  ///Triggered when an old week was deleted.
  deleted,

  ///Triggered when an error happen.
  failed,
}

class CustomPlanWeeksState extends Equatable {
  ///Cubit current state.
  ///
  ///Defaults to `CWeeksState.initial`
  final CWeeksState state;

  ///Cubit loaded weeks, defaults to an empty list.
  ///
  final List<PlanWeek> weeks;

  ///The current plan id which is assigned when first time fetch.
  final int? planID;

  ///Very general object which we can use to pass non spacific data to the ui
  ///without creating a new property for evey passed object.
  ///
  final Object? companion;

  const CustomPlanWeeksState({
    this.state = CWeeksState.initial,
    this.weeks = const [],
    this.planID = -1,
    this.companion,
  });

  @override
  List<Object?> get props => [state, weeks, planID, companion];

  CustomPlanWeeksState copyWith({
    CWeeksState? state,
    List<PlanWeek>? weeks,
    int? planID,
    Object? companion,
  }) {
    return CustomPlanWeeksState(
      state: state ?? this.state,
      weeks: weeks ?? this.weeks,
      planID: planID ?? this.planID,
      companion: companion ?? this.companion,
    );
  }

  @override
  String toString() {
    if (companion != null) {
      return '''CustomPlanWeeksState($state, length: ${weeks.length} extra -> $companion)''';
    }
    return 'CustomPlanWeeksState($state)';
  }
}

extension CheckWeek on CustomPlanWeeksState {
  bool get isInitial => state == CWeeksState.initial;
  bool get isLoading => state == CWeeksState.loading;
  bool get isGeneralLoading => state == CWeeksState.gLoading;
  bool get isGeneralFailure => state == CWeeksState.gFaliure;

  bool get isGeneralState => isGeneralLoading || isGeneralFailure;

  bool get isFetched => state == CWeeksState.fetched;
  bool get isCreated => state == CWeeksState.created;
  bool get isDeleted => state == CWeeksState.deleted;
  bool get isFailed => state == CWeeksState.failed;

  bool get isLoaded => isCreated || isDeleted || isFetched || isGeneralState;
}
