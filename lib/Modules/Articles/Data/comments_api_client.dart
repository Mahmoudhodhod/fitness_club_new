import 'package:dio/dio.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/Helpers/networking.dart';
import 'package:the_coach/Modules/Articles/Models/models.dart';

class FetchCommentsFailure implements Exception {}

class CreatingCommentFailure implements Exception {}

class DeletingCommentFailure implements Exception {}

class ArticlesCommentsApiClient {
  final Dio _client;

  ArticlesCommentsApiClient({Dio? client}) : _client = client ?? Dio();

  Future<CommentsResponse> fetchArticlesComments(String token,
      {required int articleID, String? nextPageUrl}) async {
    try {
      var uri = ArticlesNetworking.fetchArticleCommentsUri(articleID);
      if (nextPageUrl != null) uri = Uri.parse(nextPageUrl);
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchCommentsFailure();
      final _body = _response.data;
      return CommentsResponse.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<Comment> createComment(String token,
      {required String comment, required int articleID}) async {
    try {
      final uri = ArticlesNetworking.commentsUri;
      final c =
          PostAction.article(modelID: articleID, data: {'comment': comment});
      Map<String, dynamic> data = {
        'comment': comment,
        'model': 'article',
        'model_id': articleID
      };
      final _response = await _client.postUri(uri,
          options: commonOptionsWithAuthHeader(token), data: data);
      if (_response.statusCode != 200) throw CreatingCommentFailure();
      final _body = _response.data['comment'];
      return Comment.fromJson(_body);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteComment(String token, {required int commentID}) async {
    try {
      final uri = ArticlesNetworking.deleteCommentsUri(commentID);
      final _response = await _client.deleteUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw DeletingCommentFailure();
      return Future<void>.value();
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
