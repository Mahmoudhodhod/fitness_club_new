import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter_sound/flutter_sound.dart' show Codec;
import 'package:path_provider/path_provider.dart' as path_provider;

class FFmpegConverter {
  const FFmpegConverter._();

  /// Convert a sound file to a new format.
  ///
  /// - `inputFile` is the file path of the file you want to convert
  /// - `inputCodec` is the actual file format
  /// - `outputFile` is the path of the file you want to create
  /// - `outputCodec` is the new file format
  ///
  /// Be careful : `outfile` and `outputCodec` must be compatible. The output file extension must
  /// be a correct file extension for the new format.
  ///
  static Future<bool> convertFile({
    required String inputFile,
    required Codec inputCodec,
    required String outputFile,
    required Codec outputCodec,
  }) async {
    FFmpegSession session;
    final inputFilePath = await _getPath(inputFile);
    final outputFilePath = await _getPath(outputFile);
    // Do not need to re-encode. Just remux
    if (inputCodec == Codec.opusOGG && outputCodec == Codec.opusCAF) {
      session = await FFmpegKit.executeWithArguments([
        '-loglevel',
        'error',
        '-y',
        '-i',
        inputFilePath,
        '-c:a',
        'copy',
        outputFilePath,
      ]); // remux OGG to CAF
    } else {
      session = await FFmpegKit.executeWithArguments([
        '-loglevel',
        'error',
        '-y',
        '-i',
        inputFilePath,
        outputFilePath,
      ]);
    }
    return ReturnCode.isSuccess(await session.getReturnCode());
  }

  static Future<String> _getPath(String path) async {
    final index = path.indexOf('/');
    if (index >= 0) {
      return path;
    }
    final tempDir = await path_provider.getTemporaryDirectory();
    final tempPath = tempDir.path;
    return '$tempPath/$path';
  }
}
