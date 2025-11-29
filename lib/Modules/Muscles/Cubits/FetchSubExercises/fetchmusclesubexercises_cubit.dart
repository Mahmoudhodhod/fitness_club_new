import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import '../../muscles_module.dart';

part 'fetchmusclesubexercises_state.dart';
part 'search_cubit.dart';

class FetchMuscleSubExercisesCubit extends Cubit<FetchSubExercisesState> {
  FetchMuscleSubExercisesCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchExercisesInitial());

  final AuthRepository _authRepository;
  final MusclesRepository _repository;

  void fetchSubExercises(int muscleID) async {
    emit(FetchExercisesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _repository.fetchSubExercises(
        token ?? '',
        muscleID: muscleID,
      );

      emit(FetchExercisesSucceeded(
        muscleID: muscleID,
        exercises: response.exercises,
        nextPageUrl: response.nextPageUrl,
      ));
    } catch (e) {
      emit(FetchExercisesFailure(e));
    }
  }

  void fetchMoreSubExercises() async {
    if (state is FetchExercisesSucceeded) {
      final _state = state as FetchExercisesSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();

      final response = await _repository.fetchSubExercises(
        token ?? '',
        muscleID: _state.muscleID!,
        nextPageUrl: _state.nextPageUrl,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        exercises: List.of(_state.exercises)..addAll(response.exercises),
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
