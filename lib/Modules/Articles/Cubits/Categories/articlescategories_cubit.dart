import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/Models/category.dart';
import 'package:the_coach/Modules/Articles/Repository/articles_repository.dart';

part 'articlescategories_state.dart';

class FetchArticlesCategoriesCubit extends Cubit<ArticlesCategoriesState> {
  FetchArticlesCategoriesCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
  })  : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        super(const CategoriesFetchingInitial());

  final AuthRepository _authRepository;
  final ArticlesRepository _articlesRepository;

  ///Fetch articls categories from api.
  ///
  void fetchArticleCategories() async {
    emit(CategoriesFetchInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _articlesRepository.fetchCategories(token ?? '');
      emit(CategoriesFetchSucceeded(
        categories: response.categories,
        nextPageUrl: response.nextPageUrl,
      ));
    } catch (e) {
      emit(CategoriesFetchFailure(e));
    }
  }

  ///Fetch more articls categories from api when avaiable.
  ///
  void fetchMoreCategories() async {
    if (state is CategoriesFetchSucceeded) {
      final _state = state as CategoriesFetchSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();
      final currentCategories = _state.categories;

      final nextPageUri = Uri.parse(_state.nextPageUrl!);
      final response = await _articlesRepository.fetchCategories(token ?? '', nextPageUri: nextPageUri);

      emit(CategoriesFetchSucceeded(
        categories: List.of(currentCategories)..addAll(response.categories),
        paginationState: PaginationState.loaded,
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}

extension on CategoriesFetchSucceeded {
  bool get isPaginating => this.paginationState == PaginationState.paginating;
}
