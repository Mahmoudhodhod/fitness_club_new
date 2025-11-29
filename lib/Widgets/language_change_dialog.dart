import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Language dialogs which the user can choose the current app language
///
///typical use with [showDialog] method
///
///when choosing a new locale the dialog pops and returns the new locale.
///
///ex:
///```
/// showDialog<Locale>(
///   context: context,
///   builder: (_) => _hangeLanguageDialog(
///     currentLocale: Locale('ar'),
///   ),
/// )
/// ```
///
class ChangeLanguageDialog extends StatelessWidget {
  ///App's current locale.
  final Locale currentLocale;

  ///Title of the dialog is displayed in a large font at the top of the dialog.
  final String? title;

  ///Language dialogs which the user can choose the current app language
  ///
  const ChangeLanguageDialog({
    Key? key,
    required this.currentLocale,
    @visibleForTesting this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(
        title ?? LocaleKeys.drawer_settings_change_lang_title.tr(),
      ),
      content: Text(LocaleKeys.drawer_settings_change_lang_note.tr()),
      actions: [
        TextButton(
          key: Key("arabic_language"),
          onPressed: currentLocale == Locale('ar')
              ? null
              : () => Navigator.of(context).pop(Locale('ar')),
          child: Text(
            "العربية",
            style: TextStyle(
              color: CColors.switchable(
                context,
                dark: Colors.grey.shade200,
                light: CColors.darkerBlack,
              ),
            ),
          ),
        ),
        TextButton(
          key: Key("english_language"),
          onPressed: currentLocale == Locale('en')
              ? null
              : () => Navigator.of(context).pop(Locale('en')),
          child: Text("English",
              style: TextStyle(
                color: CColors.switchable(
                  context,
                  dark: CColors.primary(context),
                  light: CColors.secondary(context),
                ),
              )),
        ),
      ],
    );
  }
}
