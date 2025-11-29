import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Screens/Tabs/Articles/article_details.dart';
import 'package:the_coach/Widgets/widgets.dart';

import 'favorited_articles.dart';

class CategoryArticlesScreen extends StatelessWidget {
  final ArticleCategory category;
  const CategoryArticlesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchCubit<Article>()),
        BlocProvider(
          create: (_) => FetchArticlesCubit(
            articlesRepository: context.read<ArticlesRepository>(),
            authRepository: context.read<AuthRepository>(),
          )..fetchCategoryArticle(category.id),
        ),
        BlocProvider(
          create: (_) => SearchArticlesCubit(
            articlesRepository: context.read<ArticlesRepository>(),
            authRepository: context.read<AuthRepository>(),
            categoryID: category.id,
          ),
        ),
      ],
      child: _CategoryArticlesView(category: category),
    );
  }
}

class _CategoryArticlesView extends StatefulWidget {
  final ArticleCategory category;
  _CategoryArticlesView({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _CategoryArticlesViewState createState() => _CategoryArticlesViewState();
}

class _CategoryArticlesViewState extends State<_CategoryArticlesView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchArticlesCubit>().fetchMoreArticles();
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToArticle(Article article) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ArticlesDetailsScreen(
          article: article,
        ),
      ),
    );
  }

  void _navigateToFavoriteArticles() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoriteArticlesScreen(
          category: widget.category,
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
              header: widget.category.name,
              sliverStyle: const SliverStyle(),
              actions: [
                IconButton(
                  onPressed: _navigateToFavoriteArticles,
                  icon: Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                ),
                // _buildSearchButton(context),
              ],
            ),
            BlocBuilder<FetchArticlesCubit, FetchArticlesState>(
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
    return SliverFillRemaining(
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
              onTap: () => _navigateToArticle(article),
              isFavorite:
                  ArticleViewActionsHandler.get(context).isArticleFavorite(
                article.id,
                originalFavorite: article.isFavorite,
              ),
              imagePath: article.assets.preview,
              title: article.title,
            );
          },
          childCount: state.hasNextPage ? articles.length + 1 : articles.length,
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    final searchCubit = context.read<SearchCubit<Article>>();
    return BlocListener<SearchArticlesCubit, FetchArticlesState>(
      listener: (context, state) {
        if (state is FetchArticlesSucceeded) {
          searchCubit.showResults(state.articles,
              hasNexPageUrl: state.hasNextPage);
        } else if (state is FetchArticlesInProgress) {
          searchCubit.showLoadingIndicator();
        } else if (state is FetchArticlesFailure) {
          searchCubit.showError();
        }
      },
      child: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: Search<Article>(
                cubit: searchCubit,
                onChanged: (q) {
                  context.read<SearchArticlesCubit>().searchArticles(q);
                },
                onSelected: (article) {
                  _navigateToArticle(article);
                },
                fetchMore: () {
                  context.read<SearchArticlesCubit>().fetchMoreArticles();
                },
                itemBuilder: (context, article) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: KBorders.bc5,
                      child: SizedBox.fromSize(
                        size: Size.square(70),
                        child: ShimmerImage(
                          imageUrl: article.assets.preview,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(article.title),
                  );
                },
              ),
            );
          },
          icon: Icon(Icons.search),
        );
      }),
    );
  }
}
