import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class MultipleExercisesTile extends StatelessWidget {
  final VoidCallback? onTap;
  final DayExercise exercise;
  const MultipleExercisesTile({
    Key? key,
    this.onTap,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 15,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.cogs,
                color: CColors.primary(context), size: 40),
            const Space.h30(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exerciseType!.title,
                    style: theme(context).textTheme.bodyLarge,
                  ),
                  Text(
                    LocaleKeys.screens_general_exercises_num.tr(
                      namedArgs: {"num": exercise.exercises.length.toString()},
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconDirectional(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}
