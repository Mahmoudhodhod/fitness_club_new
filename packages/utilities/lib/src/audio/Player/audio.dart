import 'package:equatable/equatable.dart';

enum AAudioType {
  network,
  file,
  asset,
}

class AAudio extends Equatable {
  final String path;
  final String? package;
  final AAudioType audioType;
  final Map<String, String>? _networkHeaders;

  /// download audio then play it
  final bool? cached;
  final double? playSpeed;
  final double? pitch;

  Map<String, String>? get networkHeaders => _networkHeaders;
  const AAudio(
    this.path, {
    this.package,
    this.playSpeed,
    this.pitch,
  })  : audioType = AAudioType.asset,
        _networkHeaders = null,
        cached = false;

  const AAudio.file(
    this.path, {
    this.playSpeed,
    this.pitch,
  })  : audioType = AAudioType.file,
        package = null,
        _networkHeaders = null,
        cached = false;

  const AAudio.network(
    this.path, {
    Map<String, String>? headers,
    this.cached = false,
    this.playSpeed,
    this.pitch,
  })  : audioType = AAudioType.network,
        package = null,
        _networkHeaders = headers;

  // ignore: unused_element
  const AAudio._({
    required this.path,
    required this.audioType,
    this.package,
    this.cached,
    this.playSpeed,
    this.pitch,
    Map<String, String>? headers,
  }) : _networkHeaders = headers;
  @override
  List<Object?> get props {
    return [
      path,
      package,
      audioType,
      _networkHeaders,
      cached,
      playSpeed,
      pitch,
    ];
  }
}
