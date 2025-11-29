part of 'customplans_cubit.dart';

///Custom Plans State, changes when `GET` plans, update and delete.
///
enum CPlansState {
  initial,

  loading,

  ///General loading, called when you need to ONLY show a progress indicator
  ///spacific to one process, ex: when you create new plan.
  gLoading,

  ///General failure state
  gFailure,

  ///Triggerd when we want pagination without calling the api multiple times.
  ///and to stop the ui from being updated until the pagination finishes.
  paginating,

  ///Triggered when  plans were fetched.
  fetched,

  ///Triggered when a new plan was created.
  created,

  ///Triggered when an old plan was updated.
  updated,

  ///Triggered when an old plan was deleted.
  deleted,

  ///Triggered when an error happen.
  failed,
}

class CustomPlansState extends Equatable {
  ///Cubit current state.
  ///
  ///Defaults to `CPlansState.initial`
  final CPlansState state;

  ///Cubit loaded plans, defaults to an empty list.
  ///
  final List<Plan> plans;
  final String? nextPageUrl;

  ///Very general object which we can use to pass non spacific data to the ui
  ///without creating a new property for evey passed object.
  ///
  final Object? companion;

  const CustomPlansState({
    this.state = CPlansState.initial,
    this.plans = const [],
    this.nextPageUrl,
    this.companion,
  });

  @override
  List<Object?> get props => [state, plans, nextPageUrl, companion];

  CustomPlansState copyWith({
    CPlansState? state,
    List<Plan>? plans,
    String? nextPageUrl,
    Object? companion,
  }) {
    return CustomPlansState(
      state: state ?? this.state,
      plans: plans ?? this.plans,
      nextPageUrl: nextPageUrl,
      companion: companion ?? this.companion,
    );
  }

  @override
  String toString() {
    if (companion != null) {
      return '''CustomPlansState($state, length: ${plans.length}, hasNextUrl: $nextPageUrl
                extra -> $companion
             )''';
    }
    return 'CustomPlansState($state, hasNextUrl: $nextPageUrl)';
  }
}

extension Check on CustomPlansState {
  bool get isInitial => state == CPlansState.initial;
  bool get isLoading => state == CPlansState.loading;
  bool get isPaginating => state == CPlansState.paginating;
  bool get isGeneralLoading => state == CPlansState.gLoading;
  bool get isGeneralFailure => state == CPlansState.gFailure;

  bool get isGeneralState => isGeneralLoading || isGeneralFailure || isPaginating;

  bool get isFetched => state == CPlansState.fetched;
  bool get isCreated => state == CPlansState.created;
  bool get isUpdated => state == CPlansState.updated;
  bool get isDeleted => state == CPlansState.deleted;
  bool get isFailed => state == CPlansState.failed;

  bool get isLoaded => isCreated || isUpdated || isDeleted || isFetched || isGeneralState;

  bool get hasNextPage => nextPageUrl != null;

  bool get canPaginate => isLoaded && hasNextPage && !isPaginating;
}
