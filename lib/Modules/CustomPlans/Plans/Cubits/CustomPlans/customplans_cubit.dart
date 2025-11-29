import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:the_coach/Modules/CustomPlans/Plans/Repository/plans_repository.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

import '../../Models/models.dart';

part 'customplans_state.dart';

class CustomPlansCubit extends Cubit<CustomPlansState> {
  CustomPlansCubit({
    required AuthRepository authRepository,
    required CPlansRepository repository,
  })  : _authRepository = authRepository,
        _repository = repository,
        super(const CustomPlansState()) {
    _initToken();
  }

  final AuthRepository _authRepository;
  final CPlansRepository _repository;

  String? _token;

  Future<void> fetchPlans() async {
    emit(state.copyWith(state: CPlansState.loading));
    try {
      await _initToken();
      final result = await _repository.fetchPlans(_token!);
      emit(state.copyWith(
        state: CPlansState.fetched,
        plans: result.plans,
        nextPageUrl: result.nextPageUrl,
      ));
    } catch (e) {
      emit(state.copyWith(state: CPlansState.failed, companion: e));
    }
  }

  Future<void> fetchMorePlans() async {
    if (state.canPaginate) {
      await _initToken();
      emit(state.copyWith(state: CPlansState.paginating));

      final result = await _repository.fetchPlans(
        _token!,
        nextPageUrl: state.nextPageUrl,
      );

      emit(state.copyWith(
        state: CPlansState.fetched,
        plans: List.of(state.plans)..addAll(result.plans),
        nextPageUrl: result.nextPageUrl,
      ));
    }
  }

  Future<void> createPlan({required NewPlan plan}) async {
    if (!state.isLoaded) return;
    emit(state.copyWith(state: CPlansState.gLoading));
    try {
      await _initToken();
      final newPlan = await _repository.createPlan(_token!, plan: plan);
      final newPlans = [newPlan] + state.plans;
      emit(state.copyWith(
        state: CPlansState.created,
        plans: newPlans,
        companion: newPlan,
      ));
    } catch (e) {
      emit(state.copyWith(state: CPlansState.gFailure, companion: e));
    }
  }

  Future<void> deletePlan(int id) async {
    if (!state.isLoaded) return;
    try {
      await _initToken();
      await _repository.deletePlan(_token!, id: id);
      final newPlans = [...state.plans]..removeWhere((plan) => plan.id == id);
      emit(state.copyWith(
        state: CPlansState.deleted,
        plans: newPlans,
      ));
    } catch (e) {
      emit(state.copyWith(state: CPlansState.gFailure, companion: e));
    }
  }

  //TODO: impelement data plan update

  Future<void> updatePlan(int id, {required int index, required NewPlan plan}) async {
    if (!state.isLoaded) return;
    try {
      await _initToken();
      final newPlan = await _repository.updatePlan(_token!, id: id, plan: plan);
      final newPlans = _updatePlanAt(index, newPlan);
      emit(state.copyWith(
        state: CPlansState.updated,
        plans: newPlans,
        companion: newPlan,
      ));
    } catch (e) {
      emit(state.copyWith(state: CPlansState.gFailure, companion: e));
    }
  }

  Future<void> _initToken() async {
    if (_token != null) return;
    _token = await _authRepository.getUserToken();
    return Future<void>.value();
  }

  // ignore: unused_element
  bool _isPlanHere(int id) {
    final foundPlan = state.plans.firstWhere(
      (plan) => plan.id == id,
      orElse: () => Plan.empty(),
    );
    return foundPlan.isEmpty;
  }

  List<Plan> _updatePlanAt(int index, Plan plan) {
    final plans = state.plans
      ..removeAt(index)
      ..insert(index, plan);
    return plans;
  }
}
