import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Generates a list view of week's days items with each day has its exercises count.
///
class WeekDaysPreviewer extends StatelessWidget {
  final List<WeekDay> days;

  ///On day selected callback.
  ///
  final ValueChanged<WeekDay> onTap;

  const WeekDaysPreviewer({
    Key? key,
    required this.days,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: days.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const Divider(height: 0, indent: 20),
      itemBuilder: (context, index) {
        final day = days[index];
        return ListTile(
          onTap: () => onTap.call(day),
          title: Text(
            day.name,
            style: theme(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: _buildSubtitle(context, day.exercisesCount),
          trailing: IconDirectional(
            Icons.chevron_left,
            color: Colors.white54,
          ),
        );
      },
    );
  }

  ///Builds day subtitle.
  ///
  ///Shows exercises number for every day.
  ///
  Widget _buildSubtitle(BuildContext context, int? exercises) {
    final isEnglish = context.locale.isEnglish;
    final fontScaleFactor = MediaQuery.of(context).textScaleFactor;
    final fontSize = 14 * fontScaleFactor * (isEnglish ? 1.3 : 1);

    String replaceFarsiNumber(String input) {
      if(context.locale.isArabic) {
        const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const farsi = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];

        for (int i = 0; i < english.length; i++) {
          input = input.replaceAll(english[i], farsi[i]);
        }
      }
      return input;
    }

    String content = LocaleKeys.screens_general_exercises_num.tr(
      namedArgs: {"num": exercises?.toString() ?? "0"},
    );
    if (exercises == null || exercises == 0) content = LocaleKeys.general_titles_day_off_rest.tr();
    return Text(
      replaceFarsiNumber(content),
      style: GoogleFonts.cairo(fontSize: fontSize, fontWeight: FontWeight.w400, color: Colors.white), //Theme.of(context).textTheme.titleSmall,
    );
  }
}
