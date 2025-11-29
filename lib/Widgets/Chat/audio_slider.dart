part of 'audio_bubble.dart';

//TODO: refactor

class _MediaPlayerSlider extends StatefulWidget {
  ///Current audio player position.
  final Duration currentPosition;

  ///Current audio asset full duration.
  ///
  final Duration duration;

  ///Triggered when the user changes the position of the progress slider handlers.
  ///
  final ValueChanged<Duration> seekTo;

  ///Indicates that the current audio file is been loaded.
  ///
  final bool loadingAudioFile;

  ///Indicates that the current audio file is been played.
  ///
  final bool isPlaying;

  ///Triggered when the user toggle the play and pause buttons.
  ///
  final VoidCallback? onToggle;

  ///Creates an audio interactive slider.
  ///
  const _MediaPlayerSlider({
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
    this.isPlaying = false,
    this.loadingAudioFile = false,
    this.onToggle,
  });

  @override
  _MediaPlayerSliderState createState() => _MediaPlayerSliderState();
}

class _MediaPlayerSliderState extends State<_MediaPlayerSlider> {
  late Duration _visibleValue;
  late bool listenOnlyUserInterraction = false;
  late bool _isPlaying = false;

  double percent() =>
      widget.duration.inMilliseconds == 0 ? 0 : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    _visibleValue = widget.currentPosition;
    _isPlaying = widget.isPlaying;
    super.initState();
  }

  @override
  void didUpdateWidget(_MediaPlayerSlider oldWidget) {
    if (oldWidget.currentPosition != widget.currentPosition && !listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
    if (oldWidget.isPlaying != widget.isPlaying) {
      setState(() {
        _isPlaying = widget.isPlaying;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.loadingAudioFile ? "00:00" : widget.currentPosition.mmSSFormat,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.black45,
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 3.0,
                    thumbColor: CColors.primary(context),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    min: 0,
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: percent() * widget.duration.inMilliseconds.toDouble(),
                    onChangeEnd: (newValue) {
                      setState(() => listenOnlyUserInterraction = false);
                      widget.seekTo(_visibleValue);
                    },
                    onChangeStart: (_) {
                      setState(() => listenOnlyUserInterraction = true);
                    },
                    onChanged: (newValue) {
                      setState(() {
                        final to = Duration(milliseconds: newValue.floor());
                        _visibleValue = to;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          if (widget.loadingAudioFile) ...[
            SizedBox.fromSize(
              size: const Size.square(30),
              child: const Center(child: const CircularProgressIndicator(strokeWidth: 3)),
            )
          ] else ...[
            IconButton(
              constraints: BoxConstraints.tight(Size.square(30)),
              padding: EdgeInsets.zero,
              color: Colors.white,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: widget.onToggle,
            ),
          ]
        ],
      ),
    );
  }
}
