part of 'fetchmainexercises_cubit.dart';

class SearchMainExercisesCubit extends Cubit<FetchMainExercisesState> {
  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;
  final int categoryID;

  SearchMainExercisesCubit({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
    required this.categoryID,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchMainExercisesInitial());

  void searchMainExercises(String query, {required int categoryId}) async {
    emit(FetchMainExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.searchMainExercises(
        token ?? '',
        query: query,
        categoryId: categoryId,
      );
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
      final response = await _repository.searchMainExercises(
        token ?? '',
        query: '',
        nextPageUrl: _state.nextPageUrl,
        categoryId: _state.categoryId!,
      );

      emit(_state.copyWith(
        exercises: List.of(_state.exercises)..addAll(response.exercises),
        paginationState: PaginationState.loaded,
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
