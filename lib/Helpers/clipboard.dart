import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

void copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text.trim()));
  CSnackBar.custom(
    avoidNavigationBar: false,
    icon: Icon(FontAwesomeIcons.clipboard),
    messageText: LocaleKeys.general_titles_copied_to_clipboard.tr(),
  ).showWithoutContext();
}
