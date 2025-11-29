part of 'fetcharticles_cubit.dart';

class SearchArticlesCubit extends Cubit<FetchArticlesState> {
  final AuthRepository _authRepository;
  final ArticlesRepository _articlesRepository;
  final int categoryID;

  SearchArticlesCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
    required this.categoryID,
  })  : _articlesRepository = articlesRepository,
        _authRepository = authRepository,
        super(FetchArticlesInitial());

  void searchArticles(String query) async {
    emit(FetchArticlesInProgress());
    try {
      final token = await _authRepository.getUserToken();
      final response = await _articlesRepository.searchArticles(
        token ?? '',
        query: query,
        categoryID: categoryID,
      );
      emit(FetchArticlesSucceeded(
        articles: response.articles,
        nextPageUrl: response.nextPageUrl,
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
      final response = await _articlesRepository.searchArticles(
        token ?? '',
        query: '',
        nextPageUri: nextPageUri,
        categoryID: categoryID,
      );

      emit(_state.copyWith(
        paginationState: PaginationState.loaded,
        articles: List.of(currentArticles)..addAll(response.articles),
        nextPageUrl: response.nextPageUrl,
      ));
    }
  }
}
