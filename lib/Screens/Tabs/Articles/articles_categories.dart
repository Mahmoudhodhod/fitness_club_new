import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'category_articles.dart';
import 'favorited_articles.dart';

class ArticleHomeScreen extends StatelessWidget {
  const ArticleHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FetchArticlesCategoriesCubit(
        articlesRepository: context.read<ArticlesRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _ArticleHomeView(),
    );
  }
}

class _ArticleHomeView extends StatefulWidget {
  const _ArticleHomeView({Key? key}) : super(key: key);

  @override
  _ArticleHomeViewState createState() => _ArticleHomeViewState();
}

class _ArticleHomeViewState extends State<_ArticleHomeView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchArticlesCategoriesCubit>().fetchMoreCategories();
      });
    context.read<FetchArticlesCategoriesCubit>().fetchArticleCategories();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToArticles(ArticleCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryArticlesScreen(
          category: category,
        ),
      ),
    );
  }

  void _navigateToFavoriteArticles() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoriteArticlesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CDrawer(),
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CAppBar(
              header: LocaleKeys.general_titles_app_title.tr(),
              sliverStyle: const SliverStyle(),
              actions: [
                IconButton(
                  onPressed: _navigateToFavoriteArticles,
                  // onPressed: () {
                  //   CSnackBar.success(messageText: "Soon").show(context);
                  // },
                  icon: Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                ),
              ],
            ),
            BlocBuilder<FetchArticlesCategoriesCubit, ArticlesCategoriesState>(
              builder: (context, state) {
                if (state is CategoriesFetchInProgress) {
                  return _loadingIndicator();
                } else if (state is CategoriesFetchSucceeded) {
                  return _buildBody(state);
                } else if (state is CategoriesFetchFailure) {
                  return const ErrorHappened(asSliver: true);
                }
                return const SizedBox.shrink();
              },
            ),
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

  Widget _buildBody(CategoriesFetchSucceeded state) {
    final categories = state.categories;
    if (categories.isEmpty) {
      return SliverFillRemaining(child: NoDataError());
    }
    return SliverPadding(
      padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= categories.length) {
              return SizedBox.fromSize(
                size: Size.square(50),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final category = categories[index];
            return JokerListTile(
              onTap: () => _navigateToArticles(category),
              imagePath: category.assets.preview,
              titleText: category.name,
            );
          },
          childCount: state.hasNextPage ? categories.length + 1 : categories.length,
        ),
      ),
    );
  }
}
