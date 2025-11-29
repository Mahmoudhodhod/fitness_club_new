import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Audio mic flashing animation duration.
///
const _kAnimationDuration = Duration(milliseconds: 700);

///Renders a recording session and return the resulted audio file to be uploaded
///
///
class Recorder extends StatefulWidget {
  ///Triggered when the user cancels the audio recording.
  ///
  final VoidCallback? onCancel;

  ///Triggered when the user sends the audio recording.
  ///
  ///the resulted file can be [null].
  final ValueChanged<File?> onSend;

  ///Renders a recording session and return the resulted audio file to be uploaded
  const Recorder({
    Key? key,
    this.onCancel,
    required this.onSend,
  }) : super(key: key);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController;
  late final Animation<Color?> _animation;
  late final AudioRecorder _audioRecorder;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _kAnimationDuration,
    );
    _animation = Colors.red.tweenTo(Colors.transparent).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
          ),
        );
    _animationController.repeat(reverse: true);
    _audioRecorder = AudioRecorder();
    WidgetsBinding.instance
      ..addPostFrameCallback((_) => _startRecording())
      ..addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioRecorder.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _requestPermission();
    }
  }

  void _requestPermission() async {
    try {
      await _audioRecorder.requestPermission();
    } catch (e, stacktrace) {
      appLogger.d("Error while requesting audio permission", e, stacktrace);
    }
  }

  void _startRecording() async {
    try {
      await _audioRecorder.startRecording();
    } on MicPermissionException {
      if (mounted)
        showDialog(
          context: context,
          builder: (_) => _MicPermissionAlert(onCancel: _stopRecordingToSend),
        );
    } catch (e, stacktrace) {
      appLogger.e(e, e, stacktrace);
      widget.onCancel?.call();
      CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
          .showWithoutContext();
    }
  }

  void _stopRecordingToSend() async {
    final file = await _audioRecorder.stopRecording();
    widget.onSend(file);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.fancyBlack,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _animation,
            child: const Icon(Icons.mic, size: 30),
            builder: (context, child) {
              final color = _animation.value;
              return IconTheme(
                data: IconThemeData(color: color),
                child: child!,
              );
            },
          ),
          const Space.h10(),
          _buildDuration(),
          const Spacer(),
          TextButton(
            onPressed: widget.onCancel,
            child: Text(LocaleKeys.general_titles_cancel.tr()),
          ),
          IconButton(
            onPressed: _stopRecordingToSend,
            color: CColors.secondary(context),
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Widget _buildDuration() {
    return StreamBuilder<Duration>(
      stream: _audioRecorder.onRecording,
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final duration = snapshot.data!;
        return Text(
          duration.mmSSFormat,
          style: theme(context).textTheme.bodyLarge,
        );
      },
    );
  }
}

class _MicPermissionAlert extends StatelessWidget {
  final VoidCallback onCancel;
  const _MicPermissionAlert({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.error_audio_permission.tr()),
          const Space.v20(),
          const Icon(FontAwesomeIcons.microphoneSlash, size: 50),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: Text(LocaleKeys.general_titles_cancel.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            AudioRecorder.openMicSettings();
          },
          child: Text(LocaleKeys.general_titles_go_to_settings.tr()),
        ),
      ],
    );
  }
}
