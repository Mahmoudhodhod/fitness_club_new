import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import '../../plans_module.dart';

part 'fetchplans_state.dart';
part 'search_cubit.dart';

class FetchPlansCubit extends Cubit<FetchPlansState> {
  FetchPlansCubit({
    required AuthRepository authRepository,
    required PlansRepository repository,
    required FetchPlansCategoriesCubit plansCategories,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchPlansInitial()) {
    _plansCategoriesSub = plansCategories.stream.listen((state) {
      if (state is FetchCategoriesSucceeded) {
        if (state.categories.isNotEmpty) {
          return this.fetchPlans(state.categories.first.id);
        }
        return emit(FetchedPlansSuccessfully.empty);
      }
    });
  }

  final AuthRepository _authRepository;
  final PlansRepository _repository;
  late final StreamSubscription _plansCategoriesSub;

  void fetchPlans(int categoryID) async {
    emit(FetchPlansInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final data = await _repository.fetchPlans(token ?? '', categoryID: categoryID);

      emit(FetchedPlansSuccessfully(
        plans: data.plans,
        categoryID: categoryID,
        nextPageUrl: data.nextPageUrl,
      ));
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
      final data = await _repository.fetchPlans(
        token ?? '',
        categoryID: _state.categoryID!,
        nextPageUrl: _state.nextPageUrl,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        plans: List.of(_state.plans)..addAll(data.plans),
        nextPageUrl: data.nextPageUrl,
      ));
    }
  }

  @override
  Future<void> close() async {
    await _plansCategoriesSub.cancel();
    return super.close();
  }
}
