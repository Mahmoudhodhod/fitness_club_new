import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:utilities/utilities.dart';

part 'fetchplanscategories_state.dart';

class FetchPlansCategoriesCubit extends Cubit<FetchPlansCategoriesState> {
  FetchPlansCategoriesCubit({
    required AuthRepository authRepository,
    required PlansRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(FetchPlansCategoriesInitial());

  final AuthRepository _authRepository;
  final PlansRepository _repository;

  void fetchCategories() async {
    emit(FetchCategoriesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final data = await _repository.fetchPlanCategories(token ?? '');
      emit(FetchCategoriesSucceeded(categories: data.categories));
    } catch (e) {
      emit(FetchCategoriesFailed(e));
    }
  }
}
