import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

///The chat message bubble type.
///
///indicates the message sender.
///
enum BubbleType {
  ///Represents a message which was sent by the current user.
  ///
  sendBubble,

  ///Represents a message which was sent by the other user to the current on.
  ///
  receiverBubble,
}

ui.TextDirection getChatBubbleTextDirection(BubbleType type) {
  return type == BubbleType.sendBubble
      ? ui.TextDirection.rtl
      : ui.TextDirection.ltr;
}

Color getChatMessageBackgroundColor(BubbleType type) {
  return type == BubbleType.sendBubble ? Colors.blue : Colors.green;
}

bool _isOlderThan(DateTime time,
    [int days = 1, int hours = 0, int minutes = 0]) {
  final duration =
      Duration(days: days, hours: hours, minutes: minutes).inSeconds;
  return DateTime.now().timeSubInSeconds(time, fromThis: true) > duration;
}

///Represents the time at which a chat message was sent.
///
class SentTime extends StatelessWidget {
  ///The message sent time.
  final DateTime time;

  ///The Time text style.
  ///
  ///Defaults to `theme(context).textTheme.caption` with color [Colors.white38].
  ///
  final TextStyle? style;

  ///Defaults to false.
  ///
  ///if you want to show only time with no date, change to `true`.
  ///
  final bool onlyShowTime;

  ///Represents the time at which a chat message was sent.
  ///
  const SentTime({
    Key? key,
    required this.time,
    this.onlyShowTime = false,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        theme(context).textTheme.bodySmall?.copyWith(color: Colors.white38);
    final locale = NavigationService.context!.locale;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isOlderThan(time, 0, 12) && !onlyShowTime) ...[
            Text(
              _isOlderThan(time, 2)
                  ? time.toLocalizedChatMessageString(locale)
                  : time.toLocalizedChatMessageString2(locale),
              style: textStyle,
            ),
            const Space.h5(),
          ],
          Text(time.toLocalizedTimeString(locale: locale), style: textStyle),
        ],
      ),
    );
  }
}
