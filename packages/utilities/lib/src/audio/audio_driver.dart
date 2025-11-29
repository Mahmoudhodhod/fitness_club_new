import 'Player/player.dart';

export 'Player/player.dart';

///Controlles the audio playback in a collection of audio files, in our case
///chat voice records.
///
///Use [AudioDriver.instance] to return an instance.
///
///See also:
///
///* [playOrPause] Play or pause the current running player with [id].
class AudioDriver {
  AudioDriver._();

  static AudioDriver? _instance;

  ///Returns the shared [AudioDriver] instance
  factory AudioDriver.instance() {
    _instance ??= AudioDriver._();
    return _instance!;
  }

  ///The current running player's id
  String? _runningPlayerID;

  ///All currently registered players.
  ///
  final Map<String, AudioPlayer> _players = {};

  ///Play or pause the current running player with [id].
  ///
  ///* [id] The current running audio controller id.
  ///[id] must be unique.
  ///
  ///* [audio] The audio which holds all the information about
  ///the meta data of the audio file.
  ///
  ///Note: [AAudio.network(path)] is the only impelemented audio playback
  ///otherwise the method will throw assertion error.
  ///
  ///See also:
  ///* [seek] Change the current position of the song.
  ///* [dispose] Disposes and clears all registered players.
  Future<void> playOrPause(String id, AAudio audio) async {
    await _pauseOldPlayer(id);
    final player = await _registerAudioPlayer(id);
    await player.playOrPause(audio: audio);
    _runningPlayerID = id;
    return Future<void>.value();
  }

  ///returns the current runing player with [id] audio status and information.
  ///
  ///if the player doesnot exist it returns [null]
  Stream<AudioInfo>? progress(String id) {
    final player = _players[id];
    return player?.progress;
  }

  ///Change the current position of the song Tells the player to
  ///go to a specific position of the current song
  Future<void> seek(String id, Duration duration) {
    assert(_players[id] != null);
    final player = _players[id]!;
    return player.seek(duration);
  }

  ///Disposes and clears all registered players.
  ///
  ///resets the whole controller.
  ///
  Future<void> dispose() async {
    for (final key in _players.keys) {
      await _players[key]!.dispose();
    }
    _players.clear();
    _runningPlayerID = null;
  }

  Future<void> resetAllRegisteredPlayers() async {
    for (final key in _players.keys) {
      final audioPlayer = _players[key]!;
      await audioPlayer.stop();
    }
    return Future<void>.value();
  }

  ///Reigster a new player with [id].
  ///
  ///if the [id] already exists nothing happen and the old player remains.
  ///
  ///if the [id] is new an new player instance is created with the same [id].
  ///
  Future<AudioPlayer> _registerAudioPlayer(String id) async {
    final oldPlayer = _players[id];
    if (oldPlayer != null) return oldPlayer;
    final audioPlayer = AAudioPlayer();
    _players[id] = audioPlayer;
    return audioPlayer;
  }

  Future<void> _pauseOldPlayer(String id) async {
    // if the requested player is not the current on
    if (_runningPlayerID == null || _runningPlayerID == id) return;
    final playing = _players[_runningPlayerID];
    if (playing != null && playing.isPlaying) return playing.pause();
  }
}

///Formats the duration to a human readable way.
///
extension FormatAudio on Duration {
  ///Returns a realy good audio duration presentation
  ///
  ///Ex:
  ///`01:20`, `04:00` and `10:30`.
  ///
  String get mmSSFormat {
    String twoDigits(int n) => n >= 10 ? '$n' : '0$n';
    final twoDigitMinutes = twoDigits(inMinutes.remainder(Duration.minutesPerHour));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(Duration.secondsPerMinute));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
