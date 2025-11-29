///! Usless, I didn't delete this code because it took so long to build it and
/// I want it to remember that :)
///
// class SoundAudioPlayer extends AudioPlayer {
//   final FlutterSoundPlayer _player;
//   bool _startedPlaying = false;

//   SoundAudioPlayer({
//     FlutterSoundPlayer? player,
//   }) : _player = player ?? FlutterSoundPlayer();

//   @override
//   bool get isPlaying => _player.isPlaying;

//   @override
//   Stream<AudioInfo> get progress {
//     final onProgress = _player.onProgress;
//     if (onProgress == null) {
//       return Stream.value(AudioInfo.zero());
//     }
//     return _player.onProgress!.map((event) {
//       return AudioInfo(
//         currentPosition: event.position,
//         fullDuration: event.duration,
//         isPlaying: _player.isPlaying,
//       );
//     });
//   }

//   Future<void> open({required String uri, Codec codec = Codec.aacMP4}) async {
//     if (_startedPlaying) return;
//     await _player.openAudioSession();
//     await _player.setSubscriptionDuration(const Duration(seconds: 1));
//     await _player.startPlayer(fromURI: uri, codec: codec);
//     _startedPlaying = true;
//   }

//   Future<void> playOrPause() async {
//     if (_player.isPlaying) {
//       return _player.pausePlayer();
//     } else {
//       return _player.resumePlayer();
//     }
//   }

//   @override
//   Future<void> stop() {
//     return _player.stopPlayer();
//   }

//   @override
//   Future<void> seek(Duration position) {
//     return _player.seekToPlayer(position);
//   }

//   @override
//   Future<void> dispose() async {
//     await _player.stopPlayer();
//     await _player.closeAudioSession();
//   }
// }
