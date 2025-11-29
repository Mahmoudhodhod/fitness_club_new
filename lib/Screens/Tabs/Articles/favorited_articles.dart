import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Screens/Tabs/Articles/article_details.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class FavoriteArticlesScreen extends StatelessWidget {
  final ArticleCategory? category;
  const FavoriteArticlesScreen({
    Key? key,
    this.category,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FetchFavoriteArticlesCubit(
            articlesRepository: context.read<ArticlesRepository>(),
            authRepository: context.read<AuthRepository>(),
          )..fetchArticles(category?.id),
        ),
      ],
      child: _FavoriteArticlesScreen(category: category),
    );
  }
}

class _FavoriteArticlesScreen extends StatefulWidget {
  final ArticleCategory? category;
  _FavoriteArticlesScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  _FavoriteArticlesScreenState createState() => _FavoriteArticlesScreenState();
}

class _FavoriteArticlesScreenState extends State<_FavoriteArticlesScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchFavoriteArticlesCubit>().fetchMoreArticles();
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToArticles(Article article) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ArticlesDetailsScreen(
          article: article,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CAppBar(
              header: widget.category?.name ?? LocaleKeys.general_titles_favorite.tr(),
              sliverStyle: const SliverStyle(),
            ),
            BlocBuilder<FetchFavoriteArticlesCubit, FetchArticlesState>(
              builder: (context, state) {
                if (state is FetchArticlesSucceeded) {
                  return _buildBody(state);
                } else if (state is FetchArticlesFailure) {
                  return ErrorHappened(asSliver: true);
                } else {
                  return _loadingIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(FetchArticlesSucceeded state) {
    final articles = state.articles;
    if (articles.isEmpty) return SliverFillRemaining(child: NoDataError());
    return SliverPadding(
      padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= articles.length) return const PaginationLoader();
            final article = articles[index];
            return ArticleItem(
              onTap: () => _navigateToArticles(article),
              isFavorite: article.isFavorite,
              imagePath: article.assets.preview,
              title: article.title,
            );
          },
          childCount: state.hasNextPage ? articles.length + 1 : articles.length,
        ),
      ),
    );
  }
}
