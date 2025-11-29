import 'package:dio/dio.dart';
import 'package:the_coach/Modules/Articles/Helpers/networking.dart';
import 'package:the_coach/Modules/Articles/Models/models.dart';
import 'package:utilities/utilities.dart';

class FetchingArtclesCategoriesFailure implements Exception {}

class FetchingArtclesFailure implements Exception {}

class MakeArticleFavFailure implements Exception {}

class ArticlesApiClient {
  final Dio _client;

  ///Creates Articles client to handle api calls and responses.
  ///
  ArticlesApiClient({Dio? client}) : _client = client ?? Dio();

  Future<ArticleCategoriesResponse> fetchCategories(String token, {Uri? nextPageUri}) async {
    final uri = nextPageUri ?? ArticlesNetworking.articlesCategoriesUri;
    final _response = await _client.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    if (_response.statusCode != 200) throw FetchingArtclesCategoriesFailure();
    final _body = _response.data;
    return ArticleCategoriesResponse.fromJson(_body);
  }

  Future<ArticlesResponse> fetchArticles(
    String token, {
    int? categoryID,
    String? query,
    bool? isFavorite,
    Uri? nextPageUri,
  }) async {
    try {
      final uri = nextPageUri ??
          ArticlesNetworking.articleUri(
            categoryID: categoryID,
            query: query,
            favorite: isFavorite,
          );
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchingArtclesFailure();
      final _body = _response.data;
      return ArticlesResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  ///Returns [true] if the current article is now favorite and vice versa.
  ///
  Future<bool> makeArticleFav(String token, {required int articleID}) async {
    try {
      final uri = Network.favoriteUri;
      final _response = await _client.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: PostAction.article(modelID: articleID).toJson(),
      );
      if (_response.statusCode != 200) throw MakeArticleFavFailure();
      return _response.data['message'] == "create";
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<Article> fetchArticle(String token, {required int articleID}) async {
    final uri = ArticlesNetworking.articleById(articleID);
    final _response = await _client.getUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    return Article.fromJson(_response.data['article']);
  }
}
