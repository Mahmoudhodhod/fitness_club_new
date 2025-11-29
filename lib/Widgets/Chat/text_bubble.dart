import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/clipboard.dart';
import 'package:the_coach/Widgets/widgets.dart';

import '_utils.dart';

///Creates a chat text bubble.
///
class TextBubble extends StatelessWidget {
  ///The text content of the message.
  ///
  final String text;

  ///Displayed bubble type [BubbleType.receiverBubble] or [BubbleType.sendBubble].
  ///
  final BubbleType type;

  ///The time at which the current chat message was sent.
  ///
  final DateTime createdAt;

  ///Creates a chat text bubble.
  const TextBubble({
    Key? key,
    required this.text,
    required this.type,
    required this.createdAt,
  }) : super(key: key);

  void _saveToClipboard() => copyToClipboard(text);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Row(
      textDirection: getChatBubbleTextDirection(type),
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onLongPress: _saveToClipboard,
            child: Container(
              constraints: BoxConstraints(maxWidth: _size.width * 0.6, minWidth: 0),
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: getChatMessageBackgroundColor(type),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: _buildParsedText(context),
              ),
            ),
          ),
        ),
        SentTime(time: createdAt),
      ],
    );
  }

  Widget _buildParsedText(BuildContext context) {
    final isArabicText = isArabicString(text);
    final style = theme(context).textTheme.titleSmall?.copyWith(
          color: Colors.white,
        );

    return ParsedText(
      text: text.trim(),
      textDirection: !isArabicText ? ui.TextDirection.ltr : ui.TextDirection.rtl,
      parse: <MatchText>[
        MatchText(
          type: ParsedType.EMAIL,
          style: style?.copyWith(decoration: TextDecoration.underline),
          onTap: (email) => urlLauncher.launchUrl(Uri.parse("mailto:" + email)),
        ),
        MatchText(
          type: ParsedType.URL,
          style: style?.copyWith(decoration: TextDecoration.underline),
          onTap: launchUri,
        ),
        MatchText(
          type: ParsedType.PHONE,
          style: style?.copyWith(decoration: TextDecoration.underline),
          onTap: (phoneNumber) => launchUri(phoneNumber),
        ),
      ],
      style: style,
    );
  }
}
