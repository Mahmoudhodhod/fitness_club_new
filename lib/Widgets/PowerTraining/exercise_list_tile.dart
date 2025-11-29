import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Widgets/widgets.dart';

///Muscle exercise list tile which has exercise brief details like power levels and number of sub-exercises.
///
class ExerciseListTile extends StatelessWidget {
  ///Exercise center title.
  final String title;

  ///Exercise header image path.
  final String imagePath;

  ///Is the current user make is Exercise his favorite.
  final bool isFavorite;

  ///Leading tile's widget.
  ///
  ///typical usage with [ExercisePower].
  ///
  final Widget? leading;

  final VoidCallback? onTap;

  final TitlePosition? titlePosition;

  ///Muscle exercise list tile which has exercise brief details like power levels and number of sub-exercises.
  ///
  const ExerciseListTile({
    Key? key,
    required this.title,
    required this.imagePath,
    this.isFavorite = false,
    this.leading,
    this.onTap,
    this.titlePosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JokerListTile(
      estimatedHeight: screenSize.height * 0.2,
      titleText: title,
      onTap: onTap,
      leading: leading,
      imagePath: imagePath,
      titlePosition: titlePosition ?? TitlePosition.highlighted,
      trailing: Align(
        alignment: AlignmentDirectional.topEnd,
        child: FavoriteIcon(isFav: isFavorite),
      ),
    );
  }
}

///Exercise power and sub-exercise previewer.
///
class ExercisePower extends StatelessWidget {
  ///the shown title above the power level.
  final String title;

  ///Exercise over all Power level.
  ///
  ///[powerLevel] must be between `1 and 3`.
  final int powerLevel;

  const ExercisePower({
    Key? key,
    required this.title,
    this.powerLevel = 1,
  })  : assert(powerLevel > 0 && powerLevel <= 3),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.isEnglish;
    final fontScaleFactor = MediaQuery.of(context).textScaleFactor;
    final fontSize = 12 * fontScaleFactor * (isEnglish ? 1.3 : 1);

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

    return Card(
      // color: Colors.black12,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              replaceFarsiNumber(title),
              style: GoogleFonts.cairo(fontSize: fontSize, fontWeight: FontWeight.w400),textAlign: TextAlign.center,// theme(context).textTheme.bodySmall?.copyWith(color: CColors.nullableSwitchable(context, light: Colors.black),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  final _isActive = index < powerLevel;
                  return Icon(
                    _isActive ? Icons.bolt_sharp : Icons.bolt,
                    color: _isActive ? Colors.amber : Colors.white,
                    size: 15,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
