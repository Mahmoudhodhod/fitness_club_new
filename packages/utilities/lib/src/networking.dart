import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fluri/fluri.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;

///Launches the givin [uri] to a web view.
///
/// * [statusBarBrightness] Sets the status bar brightness of the application
/// after opening a link on iOS. Does nothing if no value is passed. This does
/// not handle resetting the previous status bar style.
Future<void> launchUri(String uri, {Brightness? statusBarBrightness}) async {
  final canOpen = await urllauncher.canLaunch(uri);
  if (!canOpen) return;
  await urllauncher.launch(uri, statusBarBrightness: statusBarBrightness);
  return Future<void>.value();
}

extension ExtraUri on Uri {
  ///Add network [path] to the current [Uri].
  ///
  ///Example
  ///```
  /// Uri testUri = Uri.parse("https://www.google.com");
  /// String testfragment1 = "/images";
  ///
  ///testUri.addSegment(testfragment1) -> Uri.parse("https://www.google.com/images")
  ///
  ///```
  Uri addSegment(String path) {
    final f = Fluri.fromUri(this)..appendToPath(path);
    return f.uri;
  }

  ///Add network [path]s to the current [Uri].
  ///
  ///Example
  ///```
  /// Uri testUri = Uri.parse("https://www.google.com");
  /// final testfragment1 = "/images";
  /// final testfragment2 = "/my_images";
  /// final testfragment3 = "/today";
  ///
  ///testUri.addSegment([testfragment1, testfragment2, testfragment3])
  ///-> Uri.parse("https://www.google.com/images/my_images/today")
  ///
  ///```
  Uri addSegments(List<String> paths) {
    Fluri f = Fluri.fromUri(this);
    for (final path in paths) {
      f = f..appendToPath(path);
    }
    return f.uri;
  }

  ///Add query params to the current [Uri].
  ///
  ///```
  ///final testUri = Uri.parse("https://www.google.com");
  ///
  ///testUri.addQueryParams([QueryParam(param: "q", value: "images_in_July")])
  /// -> Uri.parse("https://www.google.com?q=images_in_July")
  ///```
  ///
  Uri addQueryParams(List<QueryParam> params) {
    Fluri f = Fluri.fromUri(this);
    for (final param in params) {
      f = f..updateQuery(param.toMap(), mergeValues: true);
    }
    return f.uri;
  }
}

class QueryParam extends Equatable {
  ///Param title.
  ///
  final String param;

  ///Param value.
  ///
  final dynamic value;

  ///Uri query param.
  ///
  const QueryParam({
    required this.param,
    required this.value,
  });

  @override
  List<dynamic> get props => [param, value];

  ///Convert the current query to `{param: value}`.
  ///
  Map<String, dynamic> toMap() => {param: value.toString()};
}

extension IsUrl on String {
  bool isUrl() {
    final regex = RegExp(
      r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)",
    );
    return regex.hasMatch(this);
  }
}
