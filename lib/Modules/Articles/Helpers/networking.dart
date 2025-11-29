import 'package:utilities/utilities.dart';

class ArticlesNetworking {
  ArticlesNetworking._();
  static Uri articlesUri = Network.clientUri.addSegment("/articles");

  static Uri articlesCategoriesUri = Network.clientUri.addSegment("/categories");
  static Uri articleUri({int? categoryID, String? query, bool? favorite}) {
    return articlesUri.addQueryParams([
      if (categoryID != null) QueryParam(param: 'category_id', value: "$categoryID"),
      if (query != null) QueryParam(param: 'search', value: "$query"),
      if (favorite != null) QueryParam(param: 'is_favorite', value: "$favorite"),
    ]);
  }

  static Uri commentsUri = Network.clientUri.addSegment("/comments");
  static Uri fetchArticleCommentsUri(int articleID) {
    return commentsUri.addQueryParams([
      const QueryParam(param: 'model', value: 'article'),
      QueryParam(param: 'model_id', value: '$articleID'),
    ]);
  }

  static Uri deleteCommentsUri(int commentID) {
    return commentsUri.addSegment('/$commentID');
  }

  static Uri articleById(int id) {
    return articlesUri.addSegment('/$id');
  }
}
