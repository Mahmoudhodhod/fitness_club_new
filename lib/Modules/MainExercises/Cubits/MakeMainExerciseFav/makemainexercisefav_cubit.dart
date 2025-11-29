import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/Repository/main_exercises_repository.dart';

part 'makemainexercisefav_state.dart';

class MakeMainExerciseFavCubit extends Cubit<MakeMainExerciseFavState> {
  MakeMainExerciseFavCubit({
    required AuthRepository authRepository,
    required MainExercisesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(MakeMainExerciseFavInitial());

  final MainExercisesRepository _repository;
  final AuthRepository _authRepository;

  void makeOrDeleteFav({required int id}) async {
    emit(MakeFavInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final result = await _repository.makeMainExerciseFav(token!, exerciseID: id);
      emit(MakeFavSucceeded(isFav: result));
    } catch (e) {
      emit(MakeFavFailed(e));
    }
  }
}
