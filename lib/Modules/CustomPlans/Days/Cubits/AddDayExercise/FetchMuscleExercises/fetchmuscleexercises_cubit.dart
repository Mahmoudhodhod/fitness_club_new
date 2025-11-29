import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:utilities/utilities.dart' show ErrorState;

part 'fetchmuscleexercises_state.dart';

@Deprecated("Use FetchMuscleSubExercisesCubit instead")
class FetchMuscleExercisesCubit extends Cubit<FetchMuscleExercisesState> {
  final AuthRepository _authRepository;
  final MusclesRepository _repository;

  FetchMuscleExercisesCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository,
        super(FetchMuscleExercisesInitial());

  void fetchSubExercises(int muscleID) async {
    emit(FetchMuscleExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final result = await _repository.fetchSubExercises(token ?? '', muscleID: muscleID);
      emit(FetchMuscleExercisesSucceeded(exercises: result.exercises));
    } catch (e) {
      emit(FetchMuscleExercisesFailed(e));
    }
  }
}
