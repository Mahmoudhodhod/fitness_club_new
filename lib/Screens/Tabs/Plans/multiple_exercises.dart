import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class MultipleExercises extends StatefulWidget {
  final DayExercise dayExercise;
  const MultipleExercises({Key? key, required this.dayExercise})
      : super(key: key);

  @override
  _MultipleExercisesState createState() => _MultipleExercisesState();
}

class _MultipleExercisesState extends State<MultipleExercises> {
  late DayExercise _dayExercise;

  @override
  void initState() {
    _dayExercise = widget.dayExercise;
    super.initState();
  }

  void _navigateToSubExerciseDetails(SubExercise subExercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          slivers: [
            CAppBar(
              sliverStyle: const SliverStyle(floating: false, snap: false),
              header: _dayExercise.exerciseType!.title,
            ),
            SliverStickyHeader(
              header: _buildExerciseDetails(),
              sliver: SliverPadding(
                padding: const EdgeInsets.all(15.0),
                sliver: SliverList(
                  delegate: separatorSliverChildDelegate(
                    childCount: _dayExercise.exercises.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                      endIndent: 15,
                      indent: 15,
                    ),
                    itemBuilder: (context, index) {
                      final exercise = _dayExercise.exercises[index];
                      return _SubExerciseListTile(
                        onTap: () => _navigateToSubExerciseDetails(exercise),
                        exercise: exercise,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetails() {
    return Card(
      color: CColors.nullableSwitchable(context, dark: CColors.fancyBlack),
      margin: EdgeInsets.zero,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InfoTable(
          padding: EdgeInsets.zero,
          rows: [
            InfoTableRow(
              title: LocaleKeys.screens_general_exercise_r_sets.tr(),
              detailsText: _dayExercise.sets.toString(),
            ),
            InfoTableRow(
              title: LocaleKeys.screens_general_exercise_r_repeats.tr(),
              detailsText: cnvArabicNums(_dayExercise.reps),
            ),
            InfoTableRow(
              title: LocaleKeys.screens_general_exercise_r_rest.tr(),
              detailsText: LocaleKeys.screens_general_exercise_r_rest_time.tr(
                namedArgs: {"time": _dayExercise.restDuration.toString()},
              ),
            ),
            InfoTableRow(
              title: LocaleKeys.screens_general_exercise_r_exer_plan.tr(),
              detailsText: _dayExercise.plan,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubExerciseListTile extends StatelessWidget {
  final SubExercise exercise;
  final VoidCallback? onTap;

  const _SubExerciseListTile({
    Key? key,
    required this.exercise,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  exercise.name,
                  style: theme(context).textTheme.titleLarge,
                ),
                const Space.h10(),
                Icon(
                  FontAwesomeIcons.externalLinkAlt,
                  size: 12,
                  color: CColors.primary(context),
                ),
              ],
            ),
            const Space.v10(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ShimmerImage(
                    imageUrl: exercise.assets.url,
                    boxFit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                const TapGestureIcon(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
