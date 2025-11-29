import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Articles/Repository/articles_repository.dart';
import 'package:utilities/utilities.dart';

part 'makearticlefav_state.dart';

class MakeArticleFavCubit extends Cubit<MakeArticleFavState> {
  MakeArticleFavCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
  })  : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        super(MakearticlefavInitial());

  final AuthRepository _authRepository;
  final ArticlesRepository _articlesRepository;

  void makeOrDeleteFav({required int id}) async {
    emit(MakearticlefavInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final result = await _articlesRepository.makeArticleFav(token!, articleID: id);
      emit(MakearticlefavSucceeded(isFav: result));
    } catch (e) {
      emit(MakeArticleFavFailed(e));
    }
  }
}
