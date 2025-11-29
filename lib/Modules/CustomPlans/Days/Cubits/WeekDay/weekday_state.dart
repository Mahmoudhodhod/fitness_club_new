part of 'weekday_cubit.dart';

///Custom Days exercises State, changes when `GET` exercises, update and delete.
///
enum CDaysState {
  initial,

  loading,

  ///General loading, called when you need to ONLY show a progress indicator
  ///spacific to one process, ex: when you create new exercise.
  gLoading,

  ///General failure state
  gFailure,

  ///Triggered when  exercises were fetched.
  fetched,

  ///Triggered when a new exercise was created.
  created,

  ///Triggered when an old exercise was updated.
  updated,

  ///Triggered when an old exercise was deleted.
  deleted,

  ///Triggered when an error happen.
  failed,
}

class WeekDayState extends Equatable {
  ///Cubit current state.
  ///
  ///Defaults to `CDaysState.initial`
  final CDaysState state;

  ///Cubit loaded exercises, defaults to an empty list.
  ///
  final List<DayExercise> exercises;

  final int? dayID;

  ///Very general object which we can use to pass non spacific data to the ui
  ///without creating a new property for evey passed object.
  ///
  final Object? companion;

  const WeekDayState({
    this.state = CDaysState.initial,
    this.exercises = const [],
    this.dayID = -1,
    this.companion,
  });

  @override
  List<Object?> get props => [state, exercises, dayID, companion];

  WeekDayState copyWith({
    CDaysState? state,
    List<DayExercise>? exercises,
    int? dayID,
    Object? companion,
  }) {
    return WeekDayState(
      state: state ?? this.state,
      exercises: exercises ?? this.exercises,
      dayID: dayID ?? this.dayID,
      companion: companion ?? this.companion,
    );
  }

  @override
  String toString() {
    if (companion != null) {
      return '''WeekDayState($state, length: ${exercises.length}, extra -> $companion)''';
    }
    return 'WeekDayState($state)';
  }
}

extension CheckDayExercise on WeekDayState {
  bool get isInitial => state == CDaysState.initial;
  bool get isLoading => state == CDaysState.loading;
  bool get isGeneralLoading => state == CDaysState.gLoading;
  bool get isGeneralFailure => state == CDaysState.gFailure;

  bool get isGeneralState => isGeneralLoading || isGeneralFailure;

  bool get isFetched => state == CDaysState.fetched;
  bool get isCreated => state == CDaysState.created;
  bool get isUpdated => state == CDaysState.updated;
  bool get isDeleted => state == CDaysState.deleted;
  bool get isFailed => state == CDaysState.failed;

  bool get isLoaded => isCreated || isUpdated || isDeleted || isFetched || isGeneralState;
}
