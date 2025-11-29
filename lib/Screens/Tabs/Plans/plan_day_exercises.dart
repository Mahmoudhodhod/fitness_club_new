import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart';
import 'package:the_coach/Screens/Tabs/Plans/multiple_exercises.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'exercise_youtube_video_player.dart';

class PlanDayExercisesScreen extends StatelessWidget {
  final WeekDay day;
  const PlanDayExercisesScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchDayExercisesCubit(
        authRepository: context.read<AuthRepository>(),
        repository: context.read<PlansRepository>(),
      )..fetchDayExercises(day.id),
      child: _PlanDayExercisesView(day: day),
    );
  }
}

class _PlanDayExercisesView extends StatefulWidget {
  final WeekDay day;
  const _PlanDayExercisesView({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  State<_PlanDayExercisesView> createState() => _PlanDayExercisesViewState();
}

class _PlanDayExercisesViewState extends State<_PlanDayExercisesView> {
  void _navigateToSubExerciseDetails(
      BuildContext context, SubExercise subExercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  void _navigateToMultipleExercisesScreen(
      BuildContext context, DayExercise exercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MultipleExercises(dayExercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: Scaffold(
        body: SafeArea(
          top: !Platform.isIOS,
          child: CustomScrollView(
            slivers: [
              CAppBar(
                sliverStyle: const SliverStyle(
                  pinned: true,
                  floating: false,
                  snap: false,
                ),
                header: widget.day.name,
              ),
              BlocBuilder<FetchDayExercisesCubit, FetchDayExercisesState>(
                builder: (context, state) {
                  if (state is FetchDayExercisesSucceeded) {
                    final days = state.days;
                    if (days.isEmpty)
                      return const SliverFillRemaining(child: NoDataError());
                    return _buildBody(context, days: days);
                  } else if (state is FetchDayExercisesFailed) {
                    return const ErrorHappened(asSliver: true);
                  }

                  return _loadingIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody(BuildContext context, {required List<DayExercise> days}) {
    return SliverList(
      delegate: separatorSliverChildDelegate(
        childCount: days.length,
        separatorBuilder: (context, index) =>
            const Divider(endIndent: 15, indent: 15),
        itemBuilder: (context, index) {
          final day = days[index];
          return _buildDayExerciseTile(context, dayExercise: day);
        },
      ),
    );
  }

  Widget _buildDayExerciseTile(BuildContext context,
      {required DayExercise dayExercise}) {
    if (dayExercise.isVideoExercise) {
      final isValidContent =
          dayExercise.isVideoExercise && dayExercise.hasEmptyExercises;
      if (!isValidContent) {
        return _buildErrorVideoPlaceholder();
      }

      final videoThumbNailUrl =
          YoutubeVideoPlayer.getVideoThumbNail(dayExercise.videoUrl!);

      if (videoThumbNailUrl == null) {
        return _buildErrorVideoPlaceholder();
      }

      return DayExerciseVideoTile(
        onTap: () =>
            YoutubeVideoPlayer(url: dayExercise.videoUrl!).show(context),
        thumbnailImageUrl: videoThumbNailUrl,
      );
    }

    if (!dayExercise.hasMultipleExercises) {
      return _buildNormalNonVideoExerciseTile(context,
          dayExercise: dayExercise);
    }
    return _buildMultipleExercisesTile(context, dayExercise: dayExercise);
  }

  TitleListTile _buildErrorVideoPlaceholder() {
    return TitleListTile(
      contentPadding: EdgeInsets.all(10.0),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_outlined),
          Icon(Icons.pause),
        ],
      ),
      title: LocaleKeys.error_error_happened.tr(),
    );
  }

  Widget _buildNormalNonVideoExerciseTile(BuildContext context,
      {required DayExercise dayExercise}) {
    final exercise = dayExercise.exercises.first;
    return DayExerciseTile(
      day: dayExercise,
      onTap: () => _navigateToSubExerciseDetails(context, exercise),
      onImageTapped: () {
        SlideShow(images: [NetworkImage(exercise.assets.url)]).show(context);
      },
    );
  }

  Widget _buildMultipleExercisesTile(
    BuildContext context, {
    required DayExercise dayExercise,
  }) {
    return MultipleExercisesTile(
      onTap: () => _navigateToMultipleExercisesScreen(context, dayExercise),
      exercise: dayExercise,
    );
  }
}
