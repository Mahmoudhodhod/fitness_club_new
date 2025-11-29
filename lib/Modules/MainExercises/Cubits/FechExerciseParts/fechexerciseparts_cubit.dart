import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/Models/exercise_part.dart';
import 'package:the_coach/Modules/MainExercises/Repository/main_exercises_repository.dart';

part 'fechexerciseparts_state.dart';

class FetchExercisePartsCubit extends Cubit<FetchExercisePartsState> {
  FetchExercisePartsCubit({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchExercisePartsInitial());

  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;

  void fetchExerciseParts(int exerciseID) async {
    emit(FetchPartsInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.fetchExerciseParts(token ?? '', exerciseID: exerciseID);
      emit(FetchPartsSucceeded(mainExerciseID: exerciseID, parts: response.parts));
    } catch (e) {
      emit(FetchPartsFailed(e));
    }
  }
}
