import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Muscles/Repository/respository.dart';

part 'makesubexercisefav_state.dart';

class MakeSubExerciseFavCubit extends Cubit<MakeSubExerciseFavState> {
  MakeSubExerciseFavCubit({
    required AuthRepository authRepository,
    required MusclesRepository repository,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(MakeSubExerciseFavInitial());

  final AuthRepository _authRepository;
  final MusclesRepository _repository;

  void makeOrDeleteFav({required int id}) async {
    emit(MakeSubExerciseFavInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final result = await _repository.makeSubExerciseFav(token!, exerciseID: id);
      emit(MakeSubExerciseFavSucceeded(isFav: result));
    } catch (e) {
      emit(MakeSubExerciseFavFailed(e));
    }
  }
}
