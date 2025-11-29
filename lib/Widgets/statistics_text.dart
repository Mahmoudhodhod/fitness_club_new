import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utilities/utilities.dart';

///Shows a title and a number in a [Row] to view for example a views count.
///
class StatisticsText extends StatelessWidget {
  ///Tex† Title.
  final String title;

  ///Shown number besides the [title].
  final String number;

  final VoidCallback? onPressed;

  ///Shows a title and a number in a [Row] to view for example a views count.
  ///
  const StatisticsText({
    Key? key,
    required this.title,
    required this.number,
    this.onPressed,
  }) : super(key: key);

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

    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Text(replaceFarsiNumber(number),
          style: GoogleFonts.cairo(fontSize: fontSize, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
          const Space.h5(),
          Text(title,
          style: GoogleFonts.cairo(fontSize: fontSize, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
