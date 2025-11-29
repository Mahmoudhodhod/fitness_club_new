import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart' show Level;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:utilities/utilities.dart';

import '_ffmpeg_converter.dart';
import '_utilities.dart';

///Thrown when conversion to the required upload codec is failed.
///
class CodecConversionFailure extends AppException {}

/// A general exception thrown when the is a mic permission error.
///
class MicPermissionException implements Exception {}

/// thrown when the mic permission not `granted` but not `permanentlyDenied`.
///
class MicPermissionNotGranted implements MicPermissionException {}

/// thrown when the mic permission `permanentlyDenied`.
///
class MicPermissionPermanentlyDenied implements MicPermissionException {}

///Acts like an audio recorder which can record and save audio files to temp location in storage.
///
///you must get mic usage permission to user any of its features.
///
///See also:
///* [requestPermission] requests mic permission from the system.
///
class AudioRecorder {
  final FlutterSoundRecorder _recorder;
  // late FlutterSoundHelper _soundHelper;

  ///Acts like an audio recorder which can record and save audio files to temp location in storage.
  ///
  AudioRecorder() : _recorder = FlutterSoundRecorder(logLevel: Level.error) {
    _recorder.openRecorder();
    _recorder.setSubscriptionDuration(kFastSubscriptionSamplingRate);
    // _soundHelper = FlutterSoundHelper();
  }

  /// Opens app settings to change permission manually.
  ///
  static Future<void> openMicSettings() => openAppSettings();

  ///Requests mic permission from the system.
  ///
  ///if permission status is:
  ///- Not [granted]: it throws [MicPermissionNotGranted].
  ///- [permanentlyDenied]: it throws [MicPermissionPermanentlyDenied] and the user have to
  ///change the permission manually.
  ///
  ///See also:
  ///* [openMicSettings] opens app settings to change permission manually.
  ///
  Future<void> requestPermission() async {
    final permissionStatus = await Permission.microphone.request();
    switch (permissionStatus) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        throw MicPermissionNotGranted();
      case PermissionStatus.permanentlyDenied:
        throw MicPermissionPermanentlyDenied();
    }
  }

  ///A stream on which FlutterSound will post the recorder progression.
  ///You may listen to this Stream to have feedback on the current recording.
  Stream<Duration>? get onRecording => _recorder.onProgress?.map((e) => e.duration);

  ///Starts recording the audio to an newly created audio file.
  ///
  ///if the mic permission not granted it throws [MicPermissionException].
  ///
  ///See also:
  ///* [requestPermission] Requests mic permission from the system.
  ///* [openMicSettings] Opens app settings to change permission manually.
  ///
  Future<void> startRecording() async {
    // if (Platform.isAndroid) {
    //   throw UnsupportedError("Recording is not supported on Android");
    // }

    await requestPermission();
    final platformCodec = _CodecExt.platformCodec();
    final recordFile = await _generateTempFile(platformCodec.ext, clear: true);
    log("recordFile: $recordFile");
    try {
      return _recorder.startRecorder(
        toFile: recordFile.path,
        codec: platformCodec.codec,
      );
    } catch (_) {
      await _deleteFile(recordFile.path);
      rethrow;
    }
  }

  /// Stop a record.
  /// Return a Future to an File of the recorded sound.
  ///
  ///if the recorder isn't running it returns [null]
  ///
  ///See also:
  ///* [startRecording] Starts recording the audio to an newly created audio file.
  ///
  Future<File?> stopRecording() async {
    if (_recorder.isStopped) return null;
    final filePath = await _recorder.stopRecorder();
    if (filePath == null) return null;
    //If in android convert from aac to wav.
    if (Platform.isAndroid) {
      final platformCodec = _CodecExt.platformCodec();
      // Convert to wav
      try {
        final wavFile = await _convertCodecs(
          filePath,
          platformCodec.codec,
          outputCodec: const _CodecExt.wav(),
        );
        return wavFile;
      } catch (e, stacktrace) {
        logger.e(e, e, stacktrace);
        return null;
      }
    }

    return File(filePath);
  }

  ///Disposes the current recording session.
  ///
  Future<void> dispose() async {
    await _recorder.closeRecorder();
    await _deleteTempFiles();
    _tempFiles.clear();
    return Future<void>.value();
  }

  /// Convert a sound file to a new format.
  ///
  /// - `inputPath` is the file path of the file you want to convert
  /// - `inputCodec` is the actual file format
  /// - `outputCodec` is the new file format
  ///
  /// Be careful : `outfile` and `outputCodec` must be compatible.
  /// The output file extension must be a correct file extension for the new format.
  ///
  Future<File?> _convertCodecs(
    String inputPath,
    Codec inputCodec, {
    required _CodecExt outputCodec,
  }) async {
    // Generate output file
    final outputFile = await _generateTempFile(outputCodec.ext);

    // Convert
    final result = await FFmpegConverter.convertFile(
      inputCodec: inputCodec,
      inputFile: inputPath,
      outputCodec: outputCodec.codec,
      outputFile: outputFile.path,
    );

    if (!result) throw CodecConversionFailure();

    // Return Output file
    return outputFile;
  }

  final List<File> _tempFiles = [];

  Future<File> _generateTempFile(String ext, {bool clear = false}) async {
    final tempPath = await path_provider.getTemporaryDirectory();
    final _tempName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = p.join(tempPath.path, '$_tempName.$ext');
    final generatedFile = File(path);
    if (clear) _tempFiles.add(generatedFile);
    return generatedFile;
  }

  Future<void> _deleteTempFiles() async {
    for (final file in _tempFiles) {
      await _deleteFile(file.path);
    }
    return Future<void>.value();
  }

  Future<void> _deleteFile(String path) async {
    try {
      await File(path).delete();
    } on Exception catch (e, stacktrace) {
      logger.e("Error while deleting file", e, stacktrace);
    }
    return Future<void>.value();
  }
}

@immutable
class _CodecExt {
  final Codec codec;
  final String ext;

  const _CodecExt({
    required this.codec,
    required this.ext,
  });

  const _CodecExt.wav()
      : codec = Codec.pcm16WAV,
        ext = 'wav';

  const _CodecExt.aac()
      : codec = Codec.aacMP4,
        ext = 'aac';

  // ignore: unused_element
  const _CodecExt.mp3()
      : codec = Codec.mp3,
        ext = 'mp3';

  factory _CodecExt.platformCodec() {
    if (Platform.isAndroid) return const _CodecExt.aac();
    return const _CodecExt.wav();
  }
}
