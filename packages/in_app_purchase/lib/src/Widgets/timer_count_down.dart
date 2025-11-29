import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

//TODO: document

class FreeTrialTimer extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback? onFinished;
  final TextStyle? textStyle;

  const FreeTrialTimer({
    Key? key,
    required this.totalSeconds,
    this.onFinished,
    this.textStyle,
  }) : super(key: key);

  @override
  State<FreeTrialTimer> createState() => _FreeTrialTimerState();
}

class _FreeTrialTimerState extends State<FreeTrialTimer> {
  late final CountdownController _controller;
  late int _seconds;

  @override
  void initState() {
    _controller = CountdownController(autoStart: true);
    _seconds = widget.totalSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Countdown(
      seconds: _seconds,
      controller: _controller,
      onFinished: widget.onFinished,
      build: (context, seconds) {
        final formattedTime =
            _formateTimeFromSecondsToDayHourMinutesSeconds(seconds.round());
        return Text(
          formattedTime,
          textAlign: TextAlign.center,
          style: widget.textStyle ?? theme.textTheme.titleLarge,
        );
      },
    );
  }

  String _formateTimeFromSecondsToDayHourMinutesSeconds(int seconds) {
    final duration = Duration(seconds: seconds);
    final formatted = '${duration.inDays}:'
        '${(duration.inHours % 24).toString().padLeft(2, '0')}:'
        '${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
        // '${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
        ;
    return formatted;
  }
}
