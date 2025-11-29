import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';

import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';

class DayExerciseTile extends StatelessWidget {
  final DayExercise day;
  final VoidCallback? onTap;
  final VoidCallback? onImageTapped;

  const DayExerciseTile({
    Key? key,
    required this.day,
    this.onTap,
    this.onImageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = day.exercises.first;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SubExerciseListTile(
          onTapPreview: onImageTapped,
          data: SubExerciseTableData(
            name: exercise.name,
            sets: day.sets,
            reps: cnvArabicNums(day.reps),
            rest: day.restDuration ?? 0,
            plan: day.plan ?? '-',
            exerciseTypeTitle: day.exerciseType?.title ?? '-',
          ),
          imagePath: exercise.assets.url,
        ),
      ),
    );
  }
}
