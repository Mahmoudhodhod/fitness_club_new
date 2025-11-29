part of 'fetchmainexercises_cubit.dart';

class FetchFavoriteMainExercisesCubit extends Cubit<FetchMainExercisesState> {
  FetchFavoriteMainExercisesCubit({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchMainExercisesInitial());

  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;

  void fetchExercises() async {
    emit(FetchMainExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.favoriteMainExercises(token!);
      emit(FetchExercisesSucceeded(
        exercises: response.exercises,
        nextPageUrl: response.nextPageUrl,
      ));
    } catch (e) {
      emit(FetchMainExercisesFailed(e));
    }
  }

  void fetchMoreExercises() async {
    if (state is FetchExercisesSucceeded) {
      final _state = state as FetchExercisesSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();
      final response = await _repository.favoriteMainExercises(
        token!,
        nextPageUrl: _state.nextPageUrl,
      );

      emit(_state.copyWith(
        exercises: List.of(_state.exercises)..addAll(response.exercises),
        paginationState: PaginationState.loaded,
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
