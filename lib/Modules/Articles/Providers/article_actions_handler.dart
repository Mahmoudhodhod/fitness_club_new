import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';

///Handles all the article view metadata like comments count and favorite indications.
///
///Use [ArticleViewActionsHandler get(BuildContext)] to get an instance.
class ArticleViewActionsHandler extends ChangeNotifier {
  static ArticleViewActionsHandler get(BuildContext context) => context.read<ArticleViewActionsHandler>();

  ArticleViewModel? _article;
  Map<int, ArticleViewModel> _localDB = {};

  ArticleViewModel get article => _article ?? ArticleViewModel.empty;

  void setArticle(Article model) {
    _article = _getArticle(model.id) ?? ArticleViewModel.fromArticle(model);
    _updateArticleLocalDB();
    notifyListeners();
  }

  void toggleIsFavorite(bool isFavorite) {
    assert(_article != null);
    _article!.toggleIsFavorite(isFavorite);
    _updateArticleLocalDB();
    notifyListeners();
  }

  bool isArticleFavorite(int id, {required bool originalFavorite}) {
    return _getArticle(id)?.isFavorite ?? originalFavorite;
  }

  void addComment() {
    assert(_article != null);
    _article!.addComment();
    _updateArticleLocalDB();
    notifyListeners();
  }

  void removeComment() {
    assert(_article != null);
    _article!.removeComment();
    _updateArticleLocalDB();
    notifyListeners();
  }

  ArticleViewModel? _getArticle(int id) {
    var localDB = _localDB[id];
    return localDB;
  }

  void _updateArticleLocalDB() {
    assert(_article != null);
    final id = _article!.id;
    _localDB[id] = _article!;
  }

  @override
  void dispose() {
    _article = null;
    _localDB.clear();
    super.dispose();
  }
}
