part of 'articlecomments_cubit.dart';

///Custom Days comments State, changes when `GET` comments, update and delete.
///
enum CommentsRawState {
  initial,

  loading,

  gLoading,
  gFailed,

  paginating,

  ///Triggered when comments were fetched.
  fetched,

  ///Triggered when a new comment was created.
  created,

  ///Triggered when an old comment was deleted.
  deleted,

  ///Triggered when an error happen.
  failed,
}

class CommentsState extends Equatable {
  ///Cubit current state.
  ///
  ///Defaults to `CommentsRawState.initial`
  final CommentsRawState state;

  ///Cubit loaded exercises, defaults to an empty list.
  ///
  final List<Comment> comments;

  final String? nextPageUrl;

  final int? articleID;

  ///Very general object which we can use to pass non spacific data to the ui
  ///without creating a new property for evey passed object.
  ///
  final Object? companion;

  const CommentsState({
    this.state = CommentsRawState.initial,
    this.comments = const [],
    this.nextPageUrl,
    this.articleID = -1,
    this.companion,
  });

  @override
  String toString() {
    if (companion != null) {
      return '''CommentsState($state, length: ${comments.length}, extra -> $companion)''';
    }
    return 'CommentsState($state, nextPageUrl: $nextPageUrl)';
  }

  @override
  List<Object?> get props {
    return [
      state,
      comments,
      nextPageUrl,
      articleID,
      companion,
    ];
  }

  CommentsState copyWith({
    CommentsRawState? state,
    List<Comment>? comments,
    String? nextPageUrl,
    int? articleID,
    Object? companion,
  }) {
    return CommentsState(
      state: state ?? this.state,
      comments: comments ?? this.comments,
      nextPageUrl: nextPageUrl,
      articleID: articleID ?? this.articleID,
      companion: companion ?? this.companion,
    );
  }
}

extension CheckCommentsState on CommentsState {
  bool get isInitial => state == CommentsRawState.initial;
  bool get isLoading => state == CommentsRawState.loading;
  bool get isPaginating => state == CommentsRawState.paginating;
  bool get isGeneralLoading => state == CommentsRawState.gLoading;
  bool get isGeneralFailure => state == CommentsRawState.gFailed;

  bool get isGeneralState => isGeneralLoading || isGeneralFailure || isPaginating;

  bool get isFetched => state == CommentsRawState.fetched;
  bool get isCreated => state == CommentsRawState.created;
  bool get isDeleted => state == CommentsRawState.deleted;
  bool get isFailed => state == CommentsRawState.failed;

  bool get isLoaded => isCreated || isDeleted || isFetched || isGeneralState;

  bool get hesNextPage => this.nextPageUrl != '';

  bool get canPaginate => isLoaded && hesNextPage && !isPaginating;
}
