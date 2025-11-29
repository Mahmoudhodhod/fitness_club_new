import 'package:authentication/authentication.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/DeepLinking/deep_linking_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class MuscleExerciseDetails extends StatelessWidget {
  final SubExercise exercise;
  const MuscleExerciseDetails({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MakeSubExerciseFavCubit(
        authRepository: context.read<AuthRepository>(),
        repository: context.read<MusclesRepository>(),
      ),
      child: _MuscleExerciseDetailsView(exercise: exercise),
    );
  }
}

class _MuscleExerciseDetailsView extends StatefulWidget {
  final SubExercise exercise;
  const _MuscleExerciseDetailsView({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  _MuscleExerciseDetailsViewState createState() =>
      _MuscleExerciseDetailsViewState();
}

class _MuscleExerciseDetailsViewState
    extends State<_MuscleExerciseDetailsView> {
  late bool _isFav;

  DeepLinkOptions get _deepLinkOptions => DeepLinkOptions(
        type: ViewType.subExercise,
        id: widget.exercise.id,
        metadata: {
          'subject': widget.exercise.name,
        },
      );

  @override
  void initState() {
    AdInterstitial().showDelayed();
    _isFav = widget.exercise.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: DraggableHome(
        leading: BackButton(),
        title: Text(
          widget.exercise.name,
          style: theme(context).textTheme.bodyLarge?.copyWith(
                color: CColors.nullableSwitchable(context, light: Colors.white),
              ),
        ),
        headerWidget: _buildArticleHeader(),
        actions: [
          // _buildFavoriteButton(iconSize: 30),
          IconButton(
            onPressed: () => ShareNow.share(_deepLinkOptions),
            icon: Icon(Icons.share),
          ),

          //TODO: [Feature] impelement adding exercise to custom plan

          // IconButton(
          //   onPressed: () {},
          //   iconSize: 30,
          //   icon: Icon(
          //     Icons.add,
          //   ),
          // ),
        ],
        body: [
          Padding(
            padding: KEdgeInsets.h5,
            child: Column(
              children: [
                _buildAffectedMusclesSection(),
                const Space.v10(),
                _buildDetailsSection(),
                const Space.v5(),
                const SourcesButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      color: CColors.nullableSwitchable(context,
          light: Colors.grey.shade100, dark: CColors.darkerBlack),
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
      child: InfoTable(
        rows: [
          InfoTableRow(
            title: LocaleKeys.screens_all_muscles_body_part.tr(),
            detailsText: widget.exercise.bodyPart,
          ),
          InfoTableRow(
            title: LocaleKeys.screens_all_muscles_description.tr(),
            detailsText: widget.exercise.description,
          ),
          if (widget.exercise.steps.isNotEmpty) ...[
            InfoTableRow(
              title: LocaleKeys.screens_all_muscles_steps.tr(),
              details: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: KEdgeInsets.v5,
                itemCount: widget.exercise.steps.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final step = widget.exercise.steps[index];
                  return Row(
                    children: [
                      Space.dot(),
                      Expanded(child: Text(step)),
                    ],
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAffectedMusclesSection() {
    final exercise = widget.exercise;
    return SizedBox(
      height: screenSize.height * .25,
      child: Card(
        color: CColors.nullableSwitchable(context,
            light: Colors.grey.shade100, dark: CColors.darkerBlack),
        shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: MuscleSideEffectInfo(
                  onTap: () {
                    SlideShow(
                      images: [NetworkImage(exercise.primary.assets.url)],
                    ).show(context);
                  },
                  title: LocaleKeys.screens_all_muscles_primary_muscle.tr(),
                  subTitle: exercise.primary.name,
                  imagePath: exercise.primary.assets.url,
                ),
              ),
              const Space.h20(),
              Expanded(
                child: MuscleSideEffectInfo(
                  onTap: () {
                    SlideShow(
                      images: [NetworkImage(exercise.secondary.assets.url)],
                    ).show(context);
                  },
                  title: LocaleKeys.screens_all_muscles_secondary_muscle.tr(),
                  subTitle: exercise.secondary.name,
                  imagePath: exercise.secondary.assets.url,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              SlideShow(
                images: [NetworkImage(widget.exercise.assets.url)],
              ).show(context);
            },
            child: ShimmerImage(
              imageUrl: widget.exercise.assets.url,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        GradientShadower.stacked(height: 100.0),
        Align(
          alignment: Alignment(0, 0.8),
          child: Padding(
            padding: KEdgeInsets.h20,
            child: Text(
              widget.exercise.name,
              style: theme(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CColors.nullableSwitchable(context,
                        light: Colors.white),
                  ),
              textAlign: TextAlign.center,
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
              child: const BackButton(),
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

  //disabled sub exercise favorite
  // ignore: unused_element
  Widget _buildFavoriteButton({double? iconSize}) {
    return BlocConsumer<MakeSubExerciseFavCubit, MakeSubExerciseFavState>(
      listener: (context, state) {
        if (state is MakeSubExerciseFavFailed) {
          CSnackBar.failure(
            messageText: LocaleKeys.error_error_happened.tr(),
          ).showWithoutContext();
          _toggleFav();
        } else if (state is MakeSubExerciseFavSucceeded) {
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
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 20),
          child: FavoriteButton(
            iconSize: iconSize,
            isFavorite: _isFav,
            onChanged: (value) {
              _toggleFav();
              context
                  .read<MakeSubExerciseFavCubit>()
                  .makeOrDeleteFav(id: widget.exercise.id);
            },
          ),
        );
      },
    );
  }

  void _toggleFav() {
    setState(() => _isFav = !_isFav);
  }
}
