part of 'fetchplans_cubit.dart';

class SearchPlansCubit extends Cubit<FetchPlansState> {
  final AuthRepository _authRepository;
  final PlansRepository _repository;

  SearchPlansCubit({
    required AuthRepository authRepository,
    required PlansRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchPlansInitial());

  void searchPlans(String query) async {
    emit(FetchPlansInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final data = await _repository.searchPlans(
        token ?? '',
        query: query,
      );
      emit(
        FetchedPlansSuccessfully(
          plans: data.plans,
          nextPageUrl: data.nextPageUrl,
        ),
      );
    } catch (e) {
      emit(FetchPlansFailed(e));
    }
  }

  void fetchMorePlans() async {
    if (state is FetchedPlansSuccessfully) {
      final _state = state as FetchedPlansSuccessfully;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();
      final data = await _repository.searchPlans(
        token ?? '',
        query: '',
        nextPageUrl: _state.nextPageUrl,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        plans: List.of(_state.plans)..addAll(data.plans),
        nextPageUrl: data.nextPageUrl,
      ));
    }
  }
}
