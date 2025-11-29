import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/Models/models.dart';
import 'package:the_coach/Modules/MainExercises/Repository/main_exercises_repository.dart';

part 'fetch_favorited_exercises.dart';
part 'fetchmainexercises_state.dart';
part 'search_cubit.dart';

class FetchMainExercisesCubit extends Cubit<FetchMainExercisesState> {
  FetchMainExercisesCubit({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchMainExercisesInitial());

  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;

  void fetchMainExercises(int categoryId) async {
    emit(FetchMainExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.fetchMainExercises(
        token ?? '',
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
      final response = await _repository.fetchMainExercises(
        token ?? '',
        nextPageUrl: _state.nextPageUrl,
        categoryId: _state.categoryId!,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        exercises: List.of(_state.exercises)..addAll(response.exercises),
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
