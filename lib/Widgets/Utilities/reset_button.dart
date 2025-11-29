import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';

import 'package:the_coach/generated/locale_keys.g.dart';

///Triggers a reset callback.
///
///See also:
///* [TextButton.icon] Create a text button from a pair of widgets that serve
///as the button's [icon] and [label].
class ResetTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ResetTextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: CColors.switchableObject(
        dark: TextButton.styleFrom(
          backgroundColor: CColors.primary(context),
          disabledForegroundColor: CColors.primary(context).withOpacity(0.38),
        ),
        light: TextButton.styleFrom(
          backgroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withOpacity(0.38),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(Icons.replay, size: 16),
      label: Text(LocaleKeys.general_titles_reset.tr()),
    );
  }
}
