import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/network.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

Future<void> showSourcesDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (_) {
      return _SourcesDialog();
    },
  );
}

class _SourcesDialog extends StatelessWidget {
  const _SourcesDialog({
    Key? key,
  }) : super(key: key);

  ButtonStyle get _btnStyle => TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(64, 30),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.general_titles_what_are_our_sources.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            style: _btnStyle,
            onPressed: () {
              url_launcher.launchUrl(
                  Uri.parse("https://www.issaonline.com/blog/nutrition"));
            },
            child: Text("issaonline.com/nutrition"),
          ),
          TextButton(
            style: _btnStyle,
            onPressed: () {
              url_launcher.launchUrl(
                  Uri.parse("https://www.issaonline.com/blog/training-tips"));
            },
            child: Text("issaonline.com/training-tips"),
          ),
          TextButton(
            style: _btnStyle,
            onPressed: () {
              url_launcher.launchUrl(
                  Uri.parse("https://www.issaonline.com/blog/weight-loss"));
            },
            child: Text("issaonline.com/weight-loss"),
          ),
          TextButton(
            style: _btnStyle,
            onPressed: () {
              url_launcher.launchUrl(Uri.parse("https://blog.nasm.org/"));
            },
            child: Text("blog.nasm.org"),
          ),
          const Space.v5(),
          Text(LocaleKeys.general_titles_where_certes.tr()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: openISSACert,
          child: Text("ISSA Certificate"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.general_titles_ok.tr()),
        ),
      ],
    );
  }
}

class SourcesButton extends StatelessWidget {
  const SourcesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showSourcesDialog(context),
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: Theme.of(context).textTheme.bodySmall,
      ),
      child: Text(LocaleKeys.general_titles_what_are_our_sources.tr()),
    );
  }
}
