import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:the_coach/Modules/CustomPlans/Weeks/Repository/weeks_repository.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

part 'planweeks_state.dart';

class PlanWeeksCubit extends Cubit<CustomPlanWeeksState> {
  PlanWeeksCubit({
    required AuthRepository authRepository,
    required CWeeksRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository,
        super(const CustomPlanWeeksState()) {
    _initToken();
  }

  final AuthRepository _authRepository;
  final CWeeksRepository _repository;

  String? _token;

  Future<void> fetchWeeks(int planID) async {
    emit(state.copyWith(state: CWeeksState.loading));
    try {
      await _initToken();
      final result = await _repository.fetchPlanWeeks(_token!, planID: planID);
      emit(state.copyWith(
        state: CWeeksState.fetched,
        weeks: result.weeks,
        planID: planID,
      ));
    } catch (e) {
      emit(state.copyWith(state: CWeeksState.failed, companion: e));
    }
  }

  Future<void> createWeek() async {
    if (!state.isLoaded) return;
    emit(state.copyWith(state: CWeeksState.gLoading));
    try {
      await _initToken();
      final newWeek = await _repository.createWeek(_token!, planID: state.planID!);
      emit(state.copyWith(
        state: CWeeksState.created,
        weeks: List.of(state.weeks)..add(newWeek),
        companion: newWeek,
      ));
    } catch (e) {
      emit(state.copyWith(state: CWeeksState.gFaliure, companion: e));
    }
  }

  Future<void> deleteWeek(int weekID) async {
    if (!state.isLoaded) return;
    try {
      await _initToken();
      await _repository.deleteWeek(_token!, planID: state.planID!, weekID: weekID);
      final weeks = [...state.weeks]..removeWhere((week) => week.id == weekID);
      emit(state.copyWith(
        state: CWeeksState.deleted,
        weeks: weeks,
      ));
    } catch (e) {
      emit(state.copyWith(state: CWeeksState.gFaliure, companion: e));
    }
  }

  Future<void> _initToken() async {
    if (_token != null) return;
    _token = await _authRepository.getUserToken();
    return Future<void>.value();
  }
}
