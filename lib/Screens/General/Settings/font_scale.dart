import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Providers/providers.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

class ChangeFontScaleScreen extends StatefulWidget {
  const ChangeFontScaleScreen({Key? key}) : super(key: key);

  @override
  _ChangeFontScaleScreenState createState() => _ChangeFontScaleScreenState();
}

class _ChangeFontScaleScreenState extends State<ChangeFontScaleScreen> {
  double _value = 1;
  static const _min = 0.5;
  static const _max = 2.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _value = FontScaleHandler.get(context).fontScale;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        header: LocaleKeys.drawer_settings_text_scale_title.tr(),
        actions: [
          TextButton.icon(
            style: CColors.switchableObject(
                light: TextButton.styleFrom(backgroundColor: Colors.white)),
            onPressed: () async {
              await FontScaleHandler.get(context).changeFontScale(_value);
              WidgetsBinding.instance.reassembleApplication();
            },
            label: Text(LocaleKeys.general_titles_confirm.tr()),
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: () async {
              await FontScaleHandler.get(context).resetToDefault();
              WidgetsBinding.instance.reassembleApplication();
              if (mounted) setState(() => _value = kDefaultTextScale);
            },
            color: CColors.nullableSwitchable(context,
                dark: CColors.primary(context)),
            icon: Icon(Icons.replay),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              _buildPreviewBubbles(),
              const Spacer(),
              const Divider(color: Colors.white24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      _value.toStringAsFixed(1),
                      style: theme(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        Text("A"),
                        Expanded(
                          child: Slider.adaptive(
                            value: _value,
                            min: _min,
                            max: _max,
                            divisions: (_max / _min).round() + 2,
                            onChanged: (value) {
                              if (mounted) setState(() => this._value = value);
                            },
                          ),
                        ),
                        Text("A", style: theme(context).textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewBubbles() {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(_value)),
      child: Column(
        children: [
          _DummyTextBubble(
            text: LocaleKeys.drawer_settings_text_scale_dummy_messages_question
                .tr(),
            type: BubbleType.sendBubble,
          ),
          Space.v10(),
          _DummyTextBubble(
            text: LocaleKeys.drawer_settings_text_scale_dummy_messages_answer
                .tr(),
            type: BubbleType.receiverBubble,
          ),
          // _DummyTextBuble(
          //   text: "How do I adjast text size?",
          //   type: BubbleType.sendBubble,
          // ),
          // Space.v10(),
          // _DummyTextBuble(
          //   text: "Try adjusting the text size using the slider below!",
          //   type: BubbleType.receiverBubble,
          // ),
        ],
      ),
    );
  }
}

class _DummyTextBubble extends StatelessWidget {
  final String text;
  final BubbleType type;
  const _DummyTextBubble({
    Key? key,
    required this.text,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final isArabicText = isArabicString(text);
    return Row(
      textDirection: getChatBubbleTextDirection(type),
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: _size.width * 0.6, minWidth: 0),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: getChatMessageBackgroundColor(type),
          ),
          child: Directionality(
            textDirection:
                !isArabicText ? ui.TextDirection.ltr : ui.TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
