part of 'search_cubit.dart';

enum SearchStateEnum {
  initial,
  loading,
  succeeded,
  notFound,
  failed,
}

class SearchState<E> {
  final List<E> data;
  final SearchStateEnum sState;
  final bool hasNextPageUrl;

  const SearchState({
    this.data = const [],
    this.sState = SearchStateEnum.initial,
    this.hasNextPageUrl = false,
  });

  SearchState<E> copyWith({
    List<E>? data,
    SearchStateEnum? sState,
    bool? hasNextPageUrl,
  }) {
    return SearchState<E>(
      data: data ?? this.data,
      sState: sState ?? this.sState,
      hasNextPageUrl: hasNextPageUrl ?? this.hasNextPageUrl,
    );
  }

  @override
  String toString() => 'SearchState(state: $sState';
}
