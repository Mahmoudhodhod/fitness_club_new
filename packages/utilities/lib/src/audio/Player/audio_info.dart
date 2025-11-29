import 'package:equatable/equatable.dart';

class AudioInfo extends Equatable {
  final Duration fullDuration;
  final Duration currentPosition;
  final bool isPlaying;

  const AudioInfo({
    required this.fullDuration,
    required this.currentPosition,
    this.isPlaying = false,
  });

  const AudioInfo.zero()
      : fullDuration = Duration.zero,
        currentPosition = Duration.zero,
        isPlaying = false;

  bool get isZero => this == const AudioInfo.zero();

  bool get isNotZero => !isZero;

  @override
  String toString() => 'AudioInfo($fullDuration, p: $currentPosition, playing: $isPlaying)';

  @override
  List<Object> get props => [fullDuration, currentPosition, isPlaying];
}
