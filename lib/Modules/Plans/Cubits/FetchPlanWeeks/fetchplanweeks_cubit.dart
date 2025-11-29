import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import '../../plans_module.dart';

part 'fetchplanweeks_state.dart';

class FetchPlanWeeksCubit extends Cubit<FetchPlanWeeksState> {
  FetchPlanWeeksCubit({
    required AuthRepository authRepository,
    required PlansRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchPlanWeeksInitial());

  final AuthRepository _authRepository;
  final PlansRepository _repository;

  void fetchPlanWeeks(int planID) async {
    emit(FetchPlanWeeksInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final data = await _repository.fetchPlanWeeks(token ?? '', planID: planID);
      emit(FetchPlanWeeksSucceeded(weeks: data.weeks));
    } catch (e) {
      emit(FetchPlanWeeksFailed(e));
    }
  }
}
