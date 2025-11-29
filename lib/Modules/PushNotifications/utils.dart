import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:vibration/vibration.dart';

class NotificationsUtilities {
  static bool _didOpenFile = false;

  static Future<void> _prepareAudioFile(AssetsAudioPlayer audioPlayer) async {
    if (_didOpenFile) return;
    try {
      await audioPlayer.open(Audio("assets/audio/notification_ring.mp3"), autoStart: false);
      _didOpenFile = true;
    } on Exception catch (_) {
      _didOpenFile = false;
    }
  }

  static Future<void> notificationReceived(AssetsAudioPlayer audioPlayer) async {
    Vibration.hasVibrator().then((can) {
      if (can ?? false) Vibration.vibrate();
    }).catchError((e, stacktrace) {
      appLogger.e("Couldn't vibrate", e, stacktrace);
    });
    if (!_didOpenFile) {
      await _prepareAudioFile(audioPlayer);
    }
    try {
      if (!audioPlayer.isPlaying.value) return audioPlayer.play();
    } catch (e, stacktrace) {
      appLogger.e("Couldn't play sound", e, stacktrace);
    }
    return Future<void>.value();
  }
}
