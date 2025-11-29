import 'package:equatable/equatable.dart';

import 'package:the_coach/Modules/Articles/Models/models.dart';

// ignore: must_be_immutable
class ArticleViewModel extends Equatable {
  final int id;
  late bool _isFavorite;
  late int _favoriteCount;
  late int _commentsCount;

  bool get isFavorite => _isFavorite;
  int get favoriteCount => _favoriteCount;
  int get commentsCount => _commentsCount;

  ArticleViewModel._({
    required this.id,
    bool isFavorite = false,
    int favoriteCount = 0,
    int commentsCount = 0,
  }) {
    _isFavorite = isFavorite;
    _favoriteCount = favoriteCount;
    _commentsCount = commentsCount;
  }

  ///Creates [ArticleViewModel] from a base [Article] model.
  static ArticleViewModel fromArticle(Article article) {
    return ArticleViewModel._(
      id: article.id,
      commentsCount: article.commentsCount,
      favoriteCount: article.favoriteCount,
      isFavorite: article.isFavorite,
    );
  }

  ///Creates an empty default view model.
  static ArticleViewModel get empty {
    return ArticleViewModel._(
      id: -1,
      commentsCount: 0,
      favoriteCount: 0,
      isFavorite: false,
    );
  }

  ///Toggles favorite model state.
  void toggleIsFavorite(bool isFavorite) {
    if (isFavorite == _isFavorite) return;
    _isFavorite = isFavorite;
    _isFavorite ? _addFavoriteCount(1) : _addFavoriteCount(-1);
  }

  ///Add a fixed favorites count
  void _addFavoriteCount([int count = 1]) {
    _favoriteCount += count;
  }

  ///Adds new comment to the model.
  void addComment() => _commentsCount++;

  ///Removes comment to the model.
  void removeComment() => _commentsCount--;

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return "ArticleViewModel(isFavorite: $_isFavorite, favoriteCount: $_favoriteCount)";
  }
}
