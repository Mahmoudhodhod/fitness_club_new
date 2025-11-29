import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';
import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Sub-exercise showen data.
class SubExerciseTableData {
  ///Sub-exercise name.
  final String name;

  ///Sub-exercise sets number.
  final int sets;

  ///Represents the number of the sub-ecercise sets repeating.
  final String reps;

  ///This exercise rest time in seconds.
  final int rest;

  final String plan;

  final String? exerciseTypeTitle;

  const SubExerciseTableData({
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.plan,
    this.exerciseTypeTitle,
  });
}

class SubExerciseListTile extends StatelessWidget {
  ///Main sub-exercise image path.
  ///
  ///[GIF] is recommended.
  ///
  final String imagePath;

  ///This exercise table data, like name, sets and rest time.
  ///
  final SubExerciseTableData data;

  final VoidCallback? onTap;

  final VoidCallback? onTapPreview;

  ///Sub-exercise shown data.
  const SubExerciseListTile({
    Key? key,
    required this.imagePath,
    required this.data,
    this.onTap,
    this.onTapPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: KBorders.bc5,
      child: Card(
        color: CColors.switchable(
          context,
          dark: CColors.lightBlack,
          light: Colors.grey.shade200,
        ),
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              InfoTable(
                padding: EdgeInsets.zero,
                rows: [
                  InfoTableRow(
                    title: LocaleKeys.screens_general_exercise_r_exercise_name
                        .tr(),
                    detailsText: data.name,
                  ),
                  InfoTableRow(
                    title: LocaleKeys.screens_general_exercise_r_sets.tr(),
                    detailsText: data.sets.toString(),
                  ),
                  InfoTableRow(
                    title: LocaleKeys.screens_general_exercise_r_repeats.tr(),
                    detailsText: cnvArabicNums(data.reps),
                  ),
                  InfoTableRow(
                    title: LocaleKeys.screens_general_exercise_r_rest.tr(),
                    detailsText:
                        LocaleKeys.screens_general_exercise_r_rest_time.tr(
                      namedArgs: {"time": data.rest.toString()},
                    ),
                  ),
                  InfoTableRow(
                    title: LocaleKeys.screens_general_exercise_r_exer_plan.tr(),
                    detailsText: data.plan,
                  ),
                  if (data.exerciseTypeTitle != null)
                    InfoTableRow(
                      title: LocaleKeys.screens_general_exercise_r_exercise_type
                          .tr(),
                      detailsText: data.exerciseTypeTitle,
                    ),
                ],
              ),
              const Space.v10(),
              GestureDetector(
                onTap: onTapPreview,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      // constraints: BoxConstraints.loose(Size.fromHeight(210)),
                      child: ClipRRect(
                        borderRadius: KBorders.bc5,
                        child: ShimmerImage(
                          width: double.infinity,
                          height: 200,
                          imageUrl: imagePath,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const TapGestureIcon(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
