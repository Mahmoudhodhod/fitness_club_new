import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';
// import 'package:get/get.dart' show GetNavigation, Get;
import 'package:utilities/utilities.dart';

///Snackbar display duration time. (4 seconds is a very long time, I KNOW!)
const _snackBarDisplayDuration = Duration(seconds: 4);

class CSnackBar {
  // ignore: unused_element
  CSnackBar._(
    this.duration,
    this.icon,
    this.messageText,
    this.messageStyle,
    this.message,
    this.avoidNavigationBar,
  );

  ///Snackbar display duration, defaults to `4 seconds`.
  final Duration duration;

  ///The displayed leading icon.
  ///
  final Widget? icon;

  ///The main message string.
  final String? messageText;

  ///Message string Text style, defaults to `subtitle1`.
  ///
  final TextStyle? messageStyle;

  ///Individual Message to create more customized widget.
  final Widget? message;

  ///Avoids the bottom persistent navigation bar, defaults to `true`.
  final bool avoidNavigationBar;

  ///Returns a success snackbar with ` CupertinoIcons.check_mark_circled_solid` icon of color `green`.
  ///
  ///See also:
  ///* [show] Displays the current snackbar in [context].
  ///* [showWithoutContext] Displays the current snackbar in an auto retrived [context] from [Get].
  const CSnackBar.success({
    required this.messageText,
    this.avoidNavigationBar = true,
    this.messageStyle,
  })  : duration = _snackBarDisplayDuration,
        icon = const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.green,
        ),
        message = null;

  ///Returns a failure snackbar with ` CupertinoIcons.exclamationmark_circle_fill` icon of color `red`.
  ///
  ///See also:
  ///* [show] Displays the current snackbar in [context].
  ///* [showWithoutContext] Displays the current snackbar in an auto retrieved [context] from [Get].
  const CSnackBar.failure({
    Key? key,
    required this.messageText,
    this.avoidNavigationBar = true,
    this.messageStyle,
  })  : duration = _snackBarDisplayDuration,
        icon = const Icon(
          CupertinoIcons.exclamationmark_circle_fill,
          color: Colors.red,
        ),
        message = null;

  ///Creates a custom snackbar with an icon and a message.
  ///
  ///See also:
  ///* [show] Displays the current snackbar in [context].
  ///* [showWithoutContext] Displays the current snackbar in an auto retrieved [context] from [Get].
  const CSnackBar.custom({
    Key? key,
    this.duration = _snackBarDisplayDuration,
    this.icon,
    this.messageText,
    this.message,
    this.avoidNavigationBar = true,
    this.messageStyle,
  });

  ///Displays the current snackbar in [context].
  ///
  Future<void> show(BuildContext context) async {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    try {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: CColors.staticSwitchable(
              context,
              dark: Colors.grey.shade800,
              light: Colors.grey.shade300,
            ),
            duration: duration,
            padding:
                EdgeInsets.fromLTRB(20, 15, 20, avoidNavigationBar ? 17 : 0),
            content: Row(
              children: [
                if (icon != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(size: 30),
                    child: icon!,
                  ),
                  Space.h10(),
                ],
                Expanded(
                  child: message ??
                      Text(
                        messageText ?? '-',
                        style: textTheme.titleMedium?.merge(messageStyle),
                      ),
                ),
              ],
            ),
          ),
        );
    } on Exception catch (e, stacktrace) {
      logger.d("Error while displaying snackbar", e, stacktrace);
    }
    return Future<void>.value();
  }

  ///Displays the current snackbar in an auto retrieved [context] from [Get].
  ///
  Future<void> showWithoutContext() async {
    final _context = NavigationService.context!;
    return this.show(_context);
  }
}
