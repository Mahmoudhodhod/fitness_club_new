import 'package:authentication/authentication.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/DeepLinking/deep_linking_module.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class MainExerciseDetails extends StatelessWidget {
  final MainExercise exercise;

  const MainExerciseDetails({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _authRepo = context.read<AuthRepository>();
    var _repo = context.read<MainExercisesRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return FetchExercisePartsCubit(
              authRepository: _authRepo,
              repository: _repo,
            )..fetchExerciseParts(exercise.id);
          },
        ),
        BlocProvider(
          create: (context) {
            return MakeMainExerciseFavCubit(
              authRepository: _authRepo,
              repository: _repo,
            );
          },
        ),
      ],
      child: _PowerExerciseView(exercise: exercise),
    );
  }
}

class _PowerExerciseView extends StatefulWidget {
  final MainExercise exercise;
  const _PowerExerciseView({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _PowerExerciseViewState createState() => _PowerExerciseViewState();
}

class _PowerExerciseViewState extends State<_PowerExerciseView> {
  bool _isFavorite = false;

  DeepLinkOptions get _deepLinkOptions => DeepLinkOptions(
        type: ViewType.mainExercise,
        id: widget.exercise.id,
        metadata: {
          'subject': widget.exercise.name,
        },
      );

  @override
  void initState() {
    AdInterstitial().showDelayed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mainExerciseViewActionsHandler =
          MainExerciseViewActionsHandler.get(context);
      mainExerciseViewActionsHandler.setMainExercise(widget.exercise);
      _isFavorite = mainExerciseViewActionsHandler.exercise.isFavorite;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: DraggableHome(
        headerExpandedHeight: 0.22,
        leading: BackButton(),
        title: Text(
          widget.exercise.name,
          style: theme(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
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
          BlocBuilder<FetchExercisePartsCubit, FetchExercisePartsState>(
            builder: (context, state) {
              if (state is FetchPartsFailed) {
                return ErrorHappened();
              } else if (state is FetchPartsSucceeded) {
                return _buildDetailsBody(state);
              } else {
                return const Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          const Space.v20(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Consumer<MainExerciseViewActionsHandler>(
                      builder: (context, provider, _) {
                        final favoritesCount = provider.exercise.favoriteCount;
                        return StatisticsText(
                          title: LocaleKeys.screens_general_likes.tr(),
                          number: favoritesCount.toString(),
                        );
                      },
                    ),
                    const Spacer(),
                    const SourcesButton(),
                  ],
                ),
              ),
              const Divider(endIndent: 20, indent: 20),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _buildFavoriteButton(),
              ),
            ],
          ),
          const Space.v20(),
        ],
      ),
    );
  }

  Widget _buildDetailsBody(FetchPartsSucceeded state) {
    final parts = state.parts;
    if (parts.isEmpty) return NoDataError();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: HTMLViewer(
            data: widget.exercise.content,
          ),
        ),
        const Space.v10(),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (_, __) => Space.v10(),
          itemCount: parts.length,
          itemBuilder: (context, index) {
            final part = parts[index];
            return SubExerciseListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MuscleExerciseDetails(
                      exercise: part.subExercise,
                    ),
                  ),
                );
              },
              onTapPreview: () {
                SlideShow(
                  images: [NetworkImage(part.subExercise.assets.url)],
                ).show(context);
              },
              data: SubExerciseTableData(
                name: part.name,
                sets: part.sets,
                reps: cnvArabicNums(part.reps),
                rest: part.restDuration,
                plan: part.plan,
                exerciseTypeTitle: part.exerciseType.title,
              ),
              imagePath: part.subExercise.assets.url,
            );
          },
        ),
      ],
    );
  }

  Widget _buildArticleHeader() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => SlideShow(
              images: [
                NetworkImage(widget.exercise.assets.url),
              ],
            ).show(context),
            child: ShimmerImage(
              imageUrl: widget.exercise.assets.url,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        GradientShadower.stacked(height: 50.0),
        Align(
          alignment: Alignment(0, 0.7),
          child: Padding(
            padding: KEdgeInsets.h20,
            child: Text(
              widget.exercise.name,
              style: theme(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(-0.9, -0.5),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black45, shape: BoxShape.circle),
              child: const BackButton(),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.9, -0.5),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () => ShareNow.share(_deepLinkOptions),
              icon: Icon(Icons.share),
            ),
          ),
        ),
        const TapGestureIcon(
          size: Size.square(25),
          alignment: Alignment(0, -.5),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return BlocConsumer<MakeMainExerciseFavCubit, MakeMainExerciseFavState>(
      listener: (context, state) {
        if (state is MakeFavFailed) {
          CSnackBar.failure(
            messageText: LocaleKeys.error_error_happened.tr(),
          ).showWithoutContext();
          _toggleFav();
        } else if (state is MakeFavSucceeded) {
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
          ).showWithoutContext();
        }
      },
      builder: (context, state) {
        return FavoriteTextButton(
          isFav: _isFavorite,
          onPressed: (fav) async {
            final _requiresLogin = await requiresLogin(context);
            if (_requiresLogin) return;
            _toggleFav();
            context
                .read<MakeMainExerciseFavCubit>()
                .makeOrDeleteFav(id: widget.exercise.id);
          },
          title: LocaleKeys.screens_general_loved_it.tr(),
        );
      },
    );
  }

  void _toggleFav() {
    if (mounted) setState(() => _isFavorite = !_isFavorite);
    MainExerciseViewActionsHandler.get(context).toggleIsFavorite(_isFavorite);
  }
}
