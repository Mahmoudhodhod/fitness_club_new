import 'dart:developer';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/CustomPlans/Days/Data/api_clients.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart' show ExerciseType;

part 'fetchexercisetypes_state.dart';

class FetchExerciseTypesCubit extends Cubit<FetchExerciseTypesState> {
  final ExerciseTypesClient _exerciseTypesClient;
  final AuthRepository _authRepository;
  FetchExerciseTypesCubit({
    required ExerciseTypesClient exerciseTypesClient,
    required AuthRepository authRepository,
  })  : _exerciseTypesClient = exerciseTypesClient,
        _authRepository = authRepository,
        super(FetchExerciseTypesInitial());

  Future<void> fetchExerciseTypes() async {
    emit(FetchExerciseTypesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final types = await _exerciseTypesClient.fetchExerciseTypes(token ?? '');
      emit(FetchExerciseTypesSucceeded(types));
    } catch (e, stacktrace) {
      log("ERROR", error: e, stackTrace: stacktrace);
      emit(FetchExerciseTypesFailed(e));
    }
  }
}
