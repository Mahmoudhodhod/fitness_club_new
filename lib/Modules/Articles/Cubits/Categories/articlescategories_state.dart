part of 'articlescategories_cubit.dart';

abstract class ArticlesCategoriesState extends Equatable {
  const ArticlesCategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesFetchingInitial extends ArticlesCategoriesState {
  const CategoriesFetchingInitial();
}

class CategoriesFetchInProgress extends ArticlesCategoriesState {}

class CategoriesFetchSucceeded extends ArticlesCategoriesState {
  final List<ArticleCategory> categories;
  final String? nextPageUrl;
  final PaginationState paginationState;

  const CategoriesFetchSucceeded({
    required this.categories,
    this.nextPageUrl,
    this.paginationState = PaginationState.loaded,
  });

  bool get hasNextPage => nextPageUrl != null;

  @override
  String toString() => 'CategoriesFetchSucceeded(categories: ${categories.length}, hasNextPage: $hasNextPage)';

  @override
  List<Object?> get props => [nextPageUrl, categories, paginationState];

  CategoriesFetchSucceeded copyWith({
    List<ArticleCategory>? categories,
    String? nextPageUrl,
    PaginationState? paginationState,
  }) {
    return CategoriesFetchSucceeded(
      categories: categories ?? this.categories,
      nextPageUrl: nextPageUrl,
      paginationState: paginationState ?? this.paginationState,
    );
  }
}

class CategoriesFetchFailure extends ErrorState implements ArticlesCategoriesState {
  const CategoriesFetchFailure([Object? e]) : super(e);
}
