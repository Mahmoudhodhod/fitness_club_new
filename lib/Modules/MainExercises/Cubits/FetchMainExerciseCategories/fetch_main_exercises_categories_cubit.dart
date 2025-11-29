import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import '../../Repository/main_exercises_repository.dart';
import '../../Models/models.dart';

part 'fetch_main_exercises_categories_state.dart';

class FetchMainExerciseCategories extends Cubit<FetchMainExerciseCategoriesState> {
  FetchMainExerciseCategories({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchMainExerciseCategoriesInitial());

  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;

  void fetchCategories() async {
    emit(FetchMainExerciseCategoriesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.fetchMainExerciseCategories(token ?? '');
      emit(FetchMainExerciseCategoriesSucceeded(response.categories));
    } catch (e) {
      emit(FetchMainExerciseCategoriesFailed(e));
    }
  }
}
