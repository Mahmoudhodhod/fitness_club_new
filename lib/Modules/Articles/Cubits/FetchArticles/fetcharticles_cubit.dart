import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';

part 'fetcharticles_state.dart';
part 'searcharticles_cubit.dart';
part 'fetch_favorite_articles_cubit.dart';

class FetchArticlesCubit extends Cubit<FetchArticlesState> {
  FetchArticlesCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
  })  : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        super(FetchArticlesInitial());

  final AuthRepository _authRepository;
  final ArticlesRepository _articlesRepository;

  ///Fetch articles to a spacific category ID
  ///
  void fetchCategoryArticle(int categoryID) async {
    emit(FetchArticlesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _articlesRepository.fetchArticles(
        token ?? '',
        categoryID: categoryID,
      );
      emit(FetchArticlesSucceeded(
        articles: response.articles,
        categoryID: categoryID,
        nextPageUrl: response.nextPageUrl,
      ));
    } catch (e) {
      emit(FetchArticlesFailure(e));
    }
  }

  ///Fetch more articls from API when avaiable.
  ///
  void fetchMoreArticles() async {
    if (state is FetchArticlesSucceeded) {
      final _state = state as FetchArticlesSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();

      final currentArticles = _state.articles;

      final nextPageUri = Uri.parse(_state.nextPageUrl!);
      final response = await _articlesRepository.fetchArticles(
        token ?? '',
        categoryID: _state.categoryID!,
        nextPageUri: nextPageUri,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        articles: List.of(currentArticles)..addAll(response.articles),
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}

extension on FetchArticlesSucceeded {
  bool get isPaginating => this.paginationState == PaginationState.paginating;
}
