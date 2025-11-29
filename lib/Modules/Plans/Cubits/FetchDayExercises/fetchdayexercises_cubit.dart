import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import '../../plans_module.dart';

part 'fetchdayexercises_state.dart';

class FetchDayExercisesCubit extends Cubit<FetchDayExercisesState> {
  FetchDayExercisesCubit({
    required AuthRepository authRepository,
    required PlansRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchDayExercisesInitial());

  final AuthRepository _authRepository;
  final PlansRepository _repository;

  void fetchDayExercises(int dayID) async {
    emit(FetchDayExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final data = await _repository.fetchDayDetails(token ?? '', dayID: dayID);
      emit(FetchDayExercisesSucceeded(days: data.days));
    } catch (e) {
      emit(FetchDayExercisesFailed(e));
    }
  }
}
