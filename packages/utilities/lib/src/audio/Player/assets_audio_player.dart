import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:utilities/src/audio/Player/audio.dart';
import 'package:utilities/src/audio/Player/audio_info.dart';

import 'interface.dart';

//TODO: document

class AAudioPlayer extends AudioPlayer {
  final AssetsAudioPlayer _player;

  AAudioPlayer({
    AssetsAudioPlayer? player,
  }) : _player = player ?? AssetsAudioPlayer();

  @override
  Object? get id => _player.current.value?.audio.assetAudioPath;

  bool _initialized = false;

  @override
  bool get initialized => _initialized;

  Future<void> _openAndPlay({required AAudio audio}) async {
    Playable? playable;
    switch (audio.audioType) {
      case AAudioType.network:
        playable = Audio.network(audio.path);
        break;
      case AAudioType.file:
      case AAudioType.asset:
        break;
    }
    assert(
      playable != null,
      "[playable] was never assigned a value. "
      "You might supplied a non network audio source.",
    );

    await _player.open(playable!, playInBackground: PlayInBackground.disabledPause);
    _initialized = true;
  }

  @override
  bool get isPlaying => _player.isPlaying.value;

  @override
  Future<void> playOrPause({required AAudio audio}) async {
    if (initialized) return _player.playOrPause();
    try {
      return _openAndPlay(audio: audio);
    } on Exception catch (_) {
      _initialized = false;
      rethrow;
    }
  }

  @override
  Future<void> pause() async {
    if (!_initialized) return;
    return _player.playOrPause();
  }

  @override
  Stream<AudioInfo> get progress {
    final onProgress = _player.realtimePlayingInfos;
    return onProgress.map((event) {
      return AudioInfo(
        currentPosition: event.currentPosition,
        fullDuration: event.duration,
        isPlaying: event.isPlaying,
      );
    });
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }

  @override
  Future<void> stop() {
    return _player.stop();
  }

  @override
  Future<void> dispose() async {
    _initialized = false;

    //Just to be sure.
    await _player.stop();
    return _player.dispose();
  }
}
