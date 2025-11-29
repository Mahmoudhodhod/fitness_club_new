part of 'fetcharticles_cubit.dart';

abstract class FetchArticlesState extends Equatable {
  const FetchArticlesState();

  @override
  List<Object?> get props => [];
}

class FetchArticlesInitial extends FetchArticlesState {}

class FetchArticlesInProgress extends FetchArticlesState {}

class FetchArticlesSucceeded extends FetchArticlesState {
  final List<Article> articles;
  final String? nextPageUrl;
  final int? categoryID;
  final PaginationState paginationState;

  const FetchArticlesSucceeded({
    required this.articles,
    this.nextPageUrl,
    this.categoryID,
    this.paginationState = PaginationState.loaded,
  });

  bool get hasNextPage => nextPageUrl != null;

  @override
  String toString() => '''FetchArticlesSucceeded(categoryID: $categoryID, 
          articles: ${articles.length}, 
          hasNextPage: $hasNextPage
          state: $paginationState)
          ''';

  @override
  List<Object?> get props => [
        nextPageUrl,
        articles,
        paginationState,
      ];

  FetchArticlesSucceeded copyWith({
    List<Article>? articles,
    String? nextPageUrl,
    int? categoryID,
    PaginationState? paginationState,
  }) {
    return FetchArticlesSucceeded(
      articles: articles ?? this.articles,
      nextPageUrl: nextPageUrl,
      categoryID: categoryID ?? this.categoryID,
      paginationState: paginationState ?? this.paginationState,
    );
  }
}

class FetchArticlesFailure extends ErrorState implements FetchArticlesState {
  const FetchArticlesFailure([Object? e]) : super(e);
}
