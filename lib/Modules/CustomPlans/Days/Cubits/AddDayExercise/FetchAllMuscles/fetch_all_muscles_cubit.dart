import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:utilities/utilities.dart' show ErrorState;

part 'fetch_all_muscles_state.dart';

class FetchAllMusclesCubit extends Cubit<FetchAllMusclesState> {
  final AuthRepository _authRepository;
  final MusclesRepository _repository;

  FetchAllMusclesCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository,
        super(FetchAllMusclesInitial());

  void fetchMuscles() async {
    emit(FetchAllMusclesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final result = await _repository.fetchMuscles(token ?? '');
      emit(FetchAllMusclesSucceeded(muscles: result.muscles));
    } catch (e) {
      emit(FetchAllMusclesFailed(e));
    }
  }
}
