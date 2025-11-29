import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class ArticleCommentsScreen extends StatelessWidget {
  final Article article;
  const ArticleCommentsScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleCommentsCubit(
        authRepository: context.read<AuthRepository>(),
        articlesRepository: context.read<ArticlesRepository>(),
      )..fetchComments(article.id),
      child: _ArticleCommentsView(article: article),
    );
  }
}

class _ArticleCommentsView extends StatefulWidget {
  final Article article;
  const _ArticleCommentsView({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  _ArticleCommentsViewState createState() => _ArticleCommentsViewState();
}

class _ArticleCommentsViewState extends State<_ArticleCommentsView> {
  late final TextEditingController _commentsTextController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _commentsTextController = TextEditingController();
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<ArticleCommentsCubit>().fetchMoreComments();
      });
    super.initState();
  }

  @override
  void dispose() {
    _commentsTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNewCommentPressed() async {
    final _requiresLogin = await requiresLogin(context);
    if (_requiresLogin) return;
    final comment = _commentsTextController.text.trim();
    context.read<ArticleCommentsCubit>().createComment(comment);
  }

  void _showCommentOptionsDialog(Comment comment) {
    final List<Widget> options = [
      ListTile(
        onTap: () {
          Navigator.pop(context);
          context.read<ArticleCommentsCubit>().deleteComment(comment.id);
        },
        leading: Icon(Icons.delete, color: Colors.red),
        title: Text(LocaleKeys.screens_general_commenting_delete_comment.tr()),
      ),
    ];
    CustomBottomSheet(
      delegate: BottomSheetDelegate(
        title: LocaleKeys.general_titles_options.tr(),
        listDelegate: ListDelegate(
          itemCount: options.length,
          builder: (context, index) => options[index],
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleCommentsCubit, CommentsState>(
      listener: (context, state) {
        if (state.isDeleted) {
          CSnackBar.success(messageText: LocaleKeys.success_deleted.tr())
              .showWithoutContext();
          ArticleViewActionsHandler.get(context).removeComment();
        } else if (state.isCreated) {
          _commentsTextController.clear();
          ArticleViewActionsHandler.get(context).addComment();
        } else if (state.isGeneralFailure) {
          logError(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state.isGeneralLoading) {
          LoadingDialog.view(context);
          return;
        } else if (state.isFailed) {
          logError(state.companion);
        }
        LoadingDialog.pop(context);
      },
      child: KeyboardDismissed(
        child: Scaffold(
          body: SafeArea(
            top: !Platform.isIOS,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      CAppBar(
                        sliverStyle: const SliverStyle(),
                        header: LocaleKeys.screens_general_comments.tr(),
                      ),
                      BlocBuilder<ArticleCommentsCubit, CommentsState>(
                        builder: (context, state) {
                          if (state.isFailed) {
                            return ErrorHappened(asSliver: true);
                          } else if (state.isLoaded) {
                            return _buildBody(state);
                          }
                          return SliverFillRemaining(
                            child: Center(
                                child: const CircularProgressIndicator()),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                  top: null,
                  child: _buildNewCommentTextField(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CommentsState state) {
    if (state.comments.isEmpty) {
      return SliverFillRemaining(child: NoDataError());
    }
    final comments = state.comments;
    return SliverPadding(
      padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= comments.length) return const PaginationLoader();
            final comment = comments[index];
            return Container(
              color: index.isEven
                  ? CColors.switchable(
                      context,
                      dark: CColors.lightBlack,
                      light: Colors.grey.shade200,
                    )
                  : appTheme.scaffoldBackgroundColor,
              child: _CommentTile(
                onLongPress: () => _showCommentOptionsDialog(comment),
                comment: comment,
              ),
            );
          },
          // childCount: state.hesNextPage ? comments.length + 1 : comments.length,
          childCount: comments.length,
        ),
      ),
    );
  }

  Widget _buildNewCommentTextField() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            spreadRadius: 0.05,
            offset: Offset(0, -10),
          )
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentsTextController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: LocaleKeys.screens_general_write_a_comment.tr(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fillColor: CColors.nullableSwitchable(
                  context,
                  dark: CColors.lightBlack,
                  light: Colors.grey.shade100,
                ),
                filled: true,
                border: OutlineInputBorder(borderRadius: KBorders.bc10),
                focusedBorder: OutlineInputBorder(
                  borderRadius: KBorders.bc10,
                  borderSide: BorderSide(color: CColors.primary(context)),
                ),
              ),
            ),
          ),
          Space.h20(),
          IconButton(
            onPressed: _onNewCommentPressed,
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: Icon(Icons.send),
            color: CColors.nullableSwitchable(context,
                light: CColors.primary(context)),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onLongPress;
  const _CommentTile({
    Key? key,
    required this.comment,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final user = comment.user;
    return ListTile(
      onLongPress: onLongPress,
      leading: CCircleAvatar(url: user.image),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        comment.content,
        style: theme(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        comment.createdAt.toTimeAgo(locale: currentLocale),
      ),
    );
  }
}
