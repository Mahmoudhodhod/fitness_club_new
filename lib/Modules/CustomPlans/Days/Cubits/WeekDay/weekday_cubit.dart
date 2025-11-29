import 'dart:developer';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/CustomPlans/Days/Repository/days_repository.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

import '../../Models/models.dart';
part 'weekday_state.dart';

class WeekDayCubit extends Cubit<WeekDayState> {
  WeekDayCubit({
    required AuthRepository authRepository,
    required CDaysRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository,
        super(const WeekDayState()) {
    _initToken();
  }

  final AuthRepository _authRepository;
  final CDaysRepository _repository;

  String? _token;

  Future<void> _initToken() async {
    if (_token != null) return;
    _token = await _authRepository.getUserToken();
    return Future<void>.value();
  }

  // List<Plan> _updatePlanAt(int index, Plan plan) {
  //   final plans = state.plans
  //     ..removeAt(index)
  //     ..insert(index, plan);
  //   return plans;
  // }

  Future<void> fetchExercises(int dayID) async {
    emit(state.copyWith(state: CDaysState.loading));
    try {
      await _initToken();
      final result = await _repository.fetchDayExercises(_token!, dayID: dayID);
      emit(state.copyWith(
        state: CDaysState.fetched,
        exercises: result.days,
        dayID: dayID,
      ));
    } catch (e, stackTrace) {
      log("Error", error: e, stackTrace: stackTrace);
      emit(state.copyWith(state: CDaysState.failed, companion: e));
    }
  }

  Future<void> createExercise(NewDayExercise exercise) async {
    if (!state.isLoaded) return;
    emit(state.copyWith(state: CDaysState.gLoading));
    try {
      await _initToken();
      final newExercise = await _repository.createExercise(
        _token!,
        dayID: state.dayID!,
        exercise: exercise,
      );
      final exercises = [newExercise] + state.exercises;
      emit(state.copyWith(
        state: CDaysState.created,
        exercises: exercises,
        companion: newExercise,
      ));
      await fetchExercises(state.dayID!);
    } catch (e, stacktrace) {
      log("Error: $e\n$stacktrace");
      emit(state.copyWith(state: CDaysState.gFailure, companion: e));
    }
  }

  Future<void> deleteExercise(int exerciseID) async {
    if (!state.isLoaded) return;
    try {
      await _initToken();
      await _repository.deleteExercise(
        _token!,
        dayID: state.dayID!,
        exerciseID: exerciseID,
      );
      final exercises = List.of(state.exercises)..removeWhere((exercise) => exercise.id == exerciseID);
      emit(state.copyWith(
        state: CDaysState.deleted,
        exercises: exercises,
      ));
    } catch (e) {
      emit(state.copyWith(state: CDaysState.gFailure, companion: e));
    }
  }

  //TODO: impelement data exercise update

  // void updatePlan(int id, {required int index, required NewPlan plan}) async {
  //   if (!state.isLoaded) return;
  //   try {
  //     await _initToken();
  //     final newPlan = await _repository.updatePlan(_token!, id: id, plan: plan);
  //     final newPlans = _updatePlanAt(index, newPlan);
  //     emit(state.copyWith(
  //       state: CPlansState.updated,
  //       plans: newPlans,
  //       companion: newPlan,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(state: CPlansState.failed, companion: e));
  //   }
  // }
}
