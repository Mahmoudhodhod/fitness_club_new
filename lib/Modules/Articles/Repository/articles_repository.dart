import 'package:the_coach/Modules/Articles/Data/api_clients.dart';
import 'package:the_coach/Modules/Articles/Models/models.dart';

class ArticlesRepository {
  final ArticlesApiClient _apiClient;
  final ArticlesCommentsApiClient _commentsApiClient;

  ArticlesRepository({
    required ArticlesApiClient client,
    required ArticlesCommentsApiClient commentsClient,
  })  : _apiClient = client,
        _commentsApiClient = commentsClient;

  Future<ArticleCategoriesResponse> fetchCategories(String token, {Uri? nextPageUri}) async {
    final result = await _apiClient.fetchCategories(token, nextPageUri: nextPageUri);
    return result;
  }

  Future<ArticlesResponse> fetchArticles(
    String token, {
    required int categoryID,
    Uri? nextPageUri,
  }) async {
    final result = await _apiClient.fetchArticles(
      token,
      categoryID: categoryID,
      nextPageUri: nextPageUri,
    );
    return result;
  }

  Future<ArticlesResponse> searchArticles(
    String token, {
    required String query,
    required int categoryID,
    Uri? nextPageUri,
  }) async {
    final result = await _apiClient.fetchArticles(
      token,
      query: query,
      categoryID: categoryID,
      nextPageUri: nextPageUri,
    );
    return result;
  }

  Future<Article> fetchArticleById(String token, {required int id}) async {
    return _apiClient.fetchArticle(token, articleID: id);
  }

  Future<ArticlesResponse> fetchFavoriteArticles(
    String token, {
    int? categoryID,
    Uri? nextPageUri,
  }) async {
    final result = await _apiClient.fetchArticles(
      token,
      nextPageUri: nextPageUri,
      categoryID: categoryID,
      isFavorite: true,
    );
    return result;
  }

  Future<bool> makeArticleFav(String token, {required int articleID}) async {
    return _apiClient.makeArticleFav(token, articleID: articleID);
  }

  Future<CommentsResponse> fetchArticlesComments(
    String token, {
    required int articleID,
    String? nextPageUrl,
  }) async {
    final result = await _commentsApiClient.fetchArticlesComments(
      token,
      articleID: articleID,
      nextPageUrl: nextPageUrl,
    );
    return result;
  }

  Future<Comment> createComment(String token, {required String comment, required int articleID}) async {
    final result = await _commentsApiClient.createComment(token, comment: comment, articleID: articleID);
    return result;
  }

  Future<void> deleteComment(String token, {required int commentID}) async {
    final result = await _commentsApiClient.deleteComment(token, commentID: commentID);
    return result;
  }
}
