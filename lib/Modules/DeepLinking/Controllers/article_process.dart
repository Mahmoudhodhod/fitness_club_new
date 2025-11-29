import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Screens/Tabs/Articles/article_details.dart' show ArticlesDetailsScreen;
import 'package:the_coach/Modules/Articles/articles_module.dart' show Article, ArticlesRepository;

import '../Models/models.dart';
import '_interface.dart';

class ArticleProcess extends DeepLinkingProcess<Article> {
  final ArticlesRepository _repository;

  ArticleProcess(this._repository);

  @override
  Future<Article> executeProcess(ApiOptions options) {
    return _repository.fetchArticleById(
      options.accessToken,
      id: options.deepLinkingOptions.id,
    );
  }

  @override
  void onProcessFinished(Article article) {
    Navigator.push(
      NavigationService.context!,
      MaterialPageRoute(
        builder: (_) => ArticlesDetailsScreen(article: article),
      ),
    );
  }
}
