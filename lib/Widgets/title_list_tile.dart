import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utilities/utilities.dart';

/// a very simple [ListTile] alternative but without a subtitle.
///
class TitleListTile extends StatelessWidget {
  ///registers OnTap callback.
  final VoidCallback? onTap;

  ///tile's title.
  final String? title;

  final Widget? subtitle;

  ///title's style, defaults to: `textTheme.subtitle1`.
  final TextStyle? style;

  ///Trailing widget, in Arabic it will be at the left side and in English vice versa.
  final Widget? trailing;

  ///leading widget.
  ///
  ///recommended to use with `CircleAvatar`.
  final Widget? leading;

  ///tile's contents padding, defaults to: `contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10)`.
  final EdgeInsetsGeometry? contentPadding;

  ///Controls whether we should try to imply the trailing widget if null.
  final bool automaticallyImplyTrailing;

  /// a very simple [ListTile] alternative but without a subtitle.
  ///
  const TitleListTile({
    Key? key,
    this.onTap,
    this.title,
    this.subtitle,
    this.style,
    this.trailing,
    this.leading,
    this.contentPadding,
    this.automaticallyImplyTrailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            leading ?? const SizedBox.shrink(),
            Space.h10(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  replaceFarsiNumber(title ?? "") ,
                  key: const Key("title_section"),
                  style: GoogleFonts.cairo(fontSize: fontSize, fontWeight: FontWeight.w400),textAlign: TextAlign.center, // theme(context).textTheme.subtitle1?.merge(style),
                ),
                Space.h5(),
                subtitle ?? const SizedBox.shrink(),
              ],
            ),
            Spacer(),
            //TODO: impelement directional icon
            trailing ?? _buildDefaultTrailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultTrailing() {
    if (!automaticallyImplyTrailing) return const SizedBox();
    return Icon(
      Icons.chevron_right,
      color: Colors.white54,
    );
  }
}
