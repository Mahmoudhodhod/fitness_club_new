import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart';

part 'fetchmuscles_state.dart';

class FetchMusclesCubit extends Cubit<FetchMusclesState> {
  FetchMusclesCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchMusclesInitial());

  final AuthRepository _authRepository;
  final MusclesRepository _repository;

  void fetchMuscles() async {
    emit(FetchMusclesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.fetchMuscles(token ?? '');
      emit(FetchMusclesSucceeded(muscles: response.muscles));
    } catch (e) {
      emit(FetchMusclesFailure(e));
    }
  }
}
