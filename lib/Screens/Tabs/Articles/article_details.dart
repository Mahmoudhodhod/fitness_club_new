import 'package:authentication/authentication.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Modules/DeepLinking/deep_linking_module.dart';
import 'package:the_coach/Screens/Tabs/Articles/article_comments.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class ArticlesDetailsScreen extends StatelessWidget {
  final Article article;
  const ArticlesDetailsScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => MakeArticleFavCubit(
          articlesRepository: context.read<ArticlesRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        child: _ArticleDetailsView(
          article: article,
        ),
      );
}

class _ArticleDetailsView extends StatefulWidget {
  final Article article;
  const _ArticleDetailsView({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  _ArticleDetailsViewState createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<_ArticleDetailsView> {
  bool _isFavorite = false;

  late final Widget _htmlBody;

  DeepLinkOptions get _deepLinkOptions => DeepLinkOptions(
        type: ViewType.article,
        id: widget.article.id,
        metadata: {
          'subject': widget.article.title,
        },
      );

  @override
  void initState() {
    AdInterstitial().showDelayed();
    _htmlBody = HTMLViewer(
      data: widget.article.body,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final articleViewActionsHandler = ArticleViewActionsHandler.get(context);
      articleViewActionsHandler.setArticle(widget.article);
      _isFavorite = articleViewActionsHandler.article.isFavorite;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  void _navigateToComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ArticleCommentsScreen(
            article: widget.article,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: DraggableHome(
        leading: const BackButton(),
        title: Text(
          widget.article.title,
          style: theme(context).textTheme.bodyLarge?.copyWith(
                color: CColors.nullableSwitchable(context, light: Colors.white),
              ),
        ),
        headerWidget: _buildArticleHeader(),
        actions: [
          IconButton(
            onPressed: () => ShareNow.share(_deepLinkOptions),
            icon: Icon(Icons.share),
          ),
        ],
        body: [
          SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _htmlBody,
                _buildDataSection(),
                Divider(),
                _buildCommentingAndFavoriteSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => SlideShow(
              images: [
                NetworkImage(widget.article.assets.url),
              ],
            ).show(context),
            child: ShimmerImage(
              imageUrl: widget.article.assets.url,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        GradientShadower.stacked(height: 150.0),
        Align(
          alignment: Alignment(0, 0.8),
          child: Padding(
            padding: KEdgeInsets.h20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.article.title,
                  style: theme(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CColors.nullableSwitchable(context,
                            light: Colors.white),
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.article.createdAt
                      .toLocalizedDateTimeStr(locale: context.locale),
                  style: theme(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(-0.9, -0.7),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: BackButton(),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.9, -0.7),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () => ShareNow.share(_deepLinkOptions),
              icon: Icon(Icons.share),
            ),
          ),
        ),
        const TapGestureIcon(),
      ],
    );
  }

  Widget _buildDataSection() {
    return Consumer<ArticleViewActionsHandler>(
      builder: (context, provider, child) {
        final favoriteCount = provider.article.favoriteCount;
        final commentsCount = provider.article.commentsCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              StatisticsText(
                title: LocaleKeys.screens_general_comment.tr(),
                number: commentsCount.toString(),
              ),
              const Space.dot(),
              StatisticsText(
                title: LocaleKeys.screens_general_likes.tr(),
                number: favoriteCount.toString(),
              ),
              const Spacer(),
              const SourcesButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentingAndFavoriteSection(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: CColors.switchableBlackAndWhite,
          ),
          onPressed: _navigateToComments,
          icon: Icon(
            Icons.comment,
            color: CColors.switchableBlackAndWhite,
          ),
          label: Text(LocaleKeys.screens_general_comments.tr()),
        ),
        _buildFavButton(),
      ],
    );
  }

  Widget _buildFavButton() {
    return BlocConsumer<MakeArticleFavCubit, MakeArticleFavState>(
      listener: (context, state) {
        if (state is MakeArticleFavFailed) {
          _toggleFav();
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .show(context);
        } else if (state is MakearticlefavSucceeded) {
          final Widget _icon;
          final String _message;
          if (state.isFav) {
            _icon = Icon(Icons.favorite, color: Colors.red);
            _message = LocaleKeys.success_favorite_create;
          } else {
            _icon = Icon(FontAwesomeIcons.heartBroken, color: Colors.grey);
            _message = LocaleKeys.success_favorite_delete;
          }
          CSnackBar.custom(
            duration: const Duration(seconds: 1),
            icon: _icon,
            avoidNavigationBar: false,
            messageText: _message.tr(),
          ).show(context);
        }
      },
      builder: (context, state) {
        return FavoriteTextButton(
          isFav: _isFavorite,
          onPressed: (fav) async {
            final _requiresLogin = await requiresLogin(context);
            if (_requiresLogin) return;
            context
                .read<MakeArticleFavCubit>()
                .makeOrDeleteFav(id: widget.article.id);
            _toggleFav();
          },
          title: LocaleKeys.screens_general_loved_it.tr(),
        );
      },
    );
  }

  void _toggleFav() {
    if (mounted) setState(() => _isFavorite = !_isFavorite);
    ArticleViewActionsHandler.get(context).toggleIsFavorite(_isFavorite);
  }
}
