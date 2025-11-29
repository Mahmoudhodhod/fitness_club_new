import 'audio.dart';
import 'audio_info.dart';

//TODO: document

abstract class AudioPlayer {
  Object? id;
  bool get isPlaying;
  Stream<AudioInfo> get progress;
  bool get initialized => false;
  Future<void> playOrPause({required AAudio audio});
  Future<void> play() => throw UnimplementedError();
  Future<void> pause() => throw UnimplementedError();
  Future<void> stop() => throw UnimplementedError();
  Future<void> seek(Duration position);
  Future<void> dispose();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioPlayer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
