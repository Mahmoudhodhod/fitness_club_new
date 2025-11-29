import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

part 'audio_slider.dart';

/// Renders an audio player chat bubble to play voice notes.
///
class AudioBubble extends StatefulWidget {
  ///Played audio path.
  ///
  final String audioPath;

  ///Displayed bubble type [BubbleType.receiverBubble] or [BubbleType.sendBubble].
  ///
  final BubbleType type;

  ///The time at which the current chat message was sent.
  ///
  final DateTime createdAt;

  /// Renders an audio player chat bubble to play voice notes.
  const AudioBubble({
    Key? key,
    required this.audioPath,
    this.type = BubbleType.sendBubble,
    required this.createdAt,
  }) : super(key: key);

  @override
  _AudioBubbleState createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final _driver = AudioDriver.instance();
  bool _isLoadingAudioFile = false;

  String get _id => widget.audioPath.toString();

  void _toggleLoadingAudioIndicator() {
    if (mounted) setState(() => _isLoadingAudioFile = !_isLoadingAudioFile);
  }

  void _togglePlay() async {
    _toggleLoadingAudioIndicator();
    try {
      await _driver.playOrPause(
        _id,
        AAudio.network(widget.audioPath),
      );
    } catch (e, stacktrace) {
      appLogger.e("Error while playing/pausing audio message", e, stacktrace);

      CSnackBar.failure(
        messageText: LocaleKeys.error_error_happened.tr(),
        avoidNavigationBar: false,
      ).showWithoutContext();
    } finally {
      _toggleLoadingAudioIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const borderRadius = BorderRadius.all(Radius.circular(100));
    return Row(
      textDirection: getChatBubbleTextDirection(widget.type),
      children: [
        Expanded(
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.65),
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: CColors.fancyBlack,
              borderRadius: borderRadius,
            ),
            child: StreamBuilder<AudioInfo>(
              stream: _driver.progress(_id),
              initialData: AudioInfo.zero(),
              builder: (context, snapshot) {
                final info = snapshot.data!;
                final isPlaying = info.isPlaying;
                final fullDuration = info.fullDuration;
                final currentDuation = info.currentPosition;
                return _MediaPlayerSlider(
                  loadingAudioFile: _isLoadingAudioFile,
                  isPlaying: isPlaying,
                  duration: fullDuration,
                  currentPosition: currentDuation,
                  onToggle: () => _togglePlay(),
                  seekTo: (duration) => _driver.seek(_id, duration),
                );
              },
            ),
          ),
        ),
        SentTime(time: widget.createdAt),
      ],
    );
  }
}
