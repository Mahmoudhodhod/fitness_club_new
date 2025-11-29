part of 'fetchmusclesubexercises_cubit.dart';

class SearchMuscleSubExercisesCubit extends Cubit<FetchSubExercisesState> {
  final AuthRepository _authRepository;
  final MusclesRepository _repository;
  final int muscleId;

  SearchMuscleSubExercisesCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
    required this.muscleId,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchExercisesInitial());

  void searchSubExercises(String query) async {
    emit(FetchExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.searchSubExercises(
        token ?? '',
        query: query,
        muscleID: muscleId,
      );
      emit(FetchExercisesSucceeded(
        exercises: response.exercises,
        nextPageUrl: response.nextPageUrl,
      ));
    } catch (e, stacktrace) {
      debugPrintStack(label: e.toString(), stackTrace: stacktrace);
      emit(FetchExercisesFailure(e));
    }
  }

  void fetchMoreSubExercises() async {
    if (state is FetchExercisesSucceeded) {
      final _state = state as FetchExercisesSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();

      final response = await _repository.searchSubExercises(
        token ?? '',
        query: '',
        nextPageUrl: _state.nextPageUrl,
        muscleID: muscleId,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        exercises: List.of(_state.exercises)..addAll(response.exercises),
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
