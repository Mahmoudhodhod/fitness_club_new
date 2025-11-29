part of 'fetcharticles_cubit.dart';

class FetchFavoriteArticlesCubit extends Cubit<FetchArticlesState> {
  FetchFavoriteArticlesCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
  })  : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        super(FetchArticlesInitial());

  final AuthRepository _authRepository;
  final ArticlesRepository _articlesRepository;

  void fetchArticles([int? categoryID]) async {
    emit(FetchArticlesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _articlesRepository.fetchFavoriteArticles(
        token ?? '',
        categoryID: categoryID,
      );
      emit(FetchArticlesSucceeded(
        articles: response.articles,
        nextPageUrl: response.nextPageUrl,
        categoryID: categoryID,
      ));
    } catch (e) {
      emit(FetchArticlesFailure(e));
    }
  }

  void fetchMoreArticles() async {
    if (state is FetchArticlesSucceeded) {
      final _state = state as FetchArticlesSucceeded;

      if (_state.isPaginating || !_state.hasNextPage) return;

      emit(_state.copyWith(paginationState: PaginationState.paginating));

      final token = await _authRepository.getUserToken();
      final currentArticles = _state.articles;

      final nextPageUri = Uri.parse(_state.nextPageUrl!);
      final response = await _articlesRepository.fetchFavoriteArticles(
        token ?? '',
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
