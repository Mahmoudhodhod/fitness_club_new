import 'dart:developer';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Articles/Repository/articles_repository.dart';
import '../../../Models/models.dart';

part 'articlecomments_state.dart';

//TODO: [new] Refactor pagination
class ArticleCommentsCubit extends Cubit<CommentsState> {
  ArticleCommentsCubit({
    required AuthRepository authRepository,
    required ArticlesRepository articlesRepository,
  })  : _repository = articlesRepository,
        _authRepository = authRepository,
        super(const CommentsState());

  final AuthRepository _authRepository;
  final ArticlesRepository _repository;

  //* Fetch comments
  void fetchComments(int articleID) async {
    emit(state.copyWith(state: CommentsRawState.loading));
    try {
      final token = await _authRepository.getUserToken();
      final commentsResult = await _repository
          .fetchArticlesComments(token ?? '', articleID: articleID);
      emit(state.copyWith(
        state: CommentsRawState.fetched,
        articleID: articleID,
        comments: commentsResult.comments,
        nextPageUrl: commentsResult.nextPageUrl,
      ));
    } catch (e) {
      emit(state.copyWith(
        state: CommentsRawState.failed,
        companion: e,
      ));
    }
  }

  //* Fetch more comments
  void fetchMoreComments() async {
    if (state.canPaginate) {
      emit(state.copyWith(state: CommentsRawState.paginating));
      final token = await _authRepository.getUserToken();
      try {
        final result = await _repository.fetchArticlesComments(
          token ?? '',
          articleID: state.articleID!,
          nextPageUrl: state.nextPageUrl,
        );

        emit(state.copyWith(
          state: CommentsRawState.fetched,
          comments: List.of(state.comments)..addAll(result.comments),
          nextPageUrl: result.nextPageUrl,
        ));
      } on Exception catch (e) {
        log("Error while paginating: $e");
      }
    }
  }

  //* Create comment
  void createComment(String content) async {
    if (!state.isLoaded) return;
    emit(state.copyWith(state: CommentsRawState.gLoading));

    try {
      final token = await _authRepository.getUserToken();
      final comment = await _repository.createComment(
        token!,
        comment: content,
        articleID: state.articleID!,
      );

      emit(state.copyWith(
        comments: [comment]..addAll(state.comments),
        state: CommentsRawState.created,
      ));
    } catch (e) {
      emit(state.copyWith(state: CommentsRawState.gFailed, companion: e));
    }
  }

  //* Delete comment
  void deleteComment(int commentID) async {
    if (!state.isLoaded) return;
    emit(state.copyWith(state: CommentsRawState.gLoading));
    try {
      final token = await _authRepository.getUserToken();
      await _repository.deleteComment(token!, commentID: commentID);
      final newComments = List.of(state.comments)
        ..removeWhere((comment) => comment.id == commentID);
      emit(state.copyWith(
        state: CommentsRawState.deleted,
        comments: newComments,
      ));
    } catch (e) {
      emit(state.copyWith(state: CommentsRawState.gFailed, companion: e));
    }
  }
}
