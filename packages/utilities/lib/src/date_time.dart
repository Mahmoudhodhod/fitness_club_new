import 'dart:ui';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

//TODO: document
///TODO: test

extension Format on DateTime {
  String toLocalizedChatMessageString([Locale locale = const Locale('ar')]) {
    final _langCode = locale.languageCode;
    return DateFormat("E,\tM/d", _langCode).format(this);
  }

  String toLocalizedChatMessageString2([Locale locale = const Locale('ar')]) {
    final _langCode = locale.languageCode;
    String _string = "MMMM d";
    if (_langCode == 'ar') _string = _string.split(" ").reversed.join(" ");
    return DateFormat(_string, _langCode).format(this);
  }

  String toLocalizedDateTimeStr({String? format, Locale? locale}) {
    final _langCode = locale?.languageCode ?? 'en';
    if (format != null) return DateFormat(format, _langCode).format(toLocal());
    return DateFormat("d MMMM y\t\thh:mm aaa", _langCode).format(toLocal());
  }

  String toLocalizedTimeString({required Locale locale}) {
    final _langCode = locale.languageCode;
    return DateFormat("hh:mm aaa", _langCode).format(this);
  }

  String toLocalizedDateString({required Locale locale}) {
    final _langCode = locale.languageCode;
    return DateFormat("d MMMM y", _langCode).format(this);
  }

  String getPublishingDate({required Locale locale}) {
    return DateTimeFormat.format(this, format: DateTimeFormats.european);
  }

  String toTimeAgo({required Locale locale}) {
    final _timeDefInSeconds = timeSubInSeconds(this);
    final ago = DateTime.now().subtract(Duration(seconds: _timeDefInSeconds));
    if (locale.languageCode == 'ar') timeago.setLocaleMessages('ar', timeago.ArMessages());
    return timeago.format(ago, locale: locale.languageCode);
  }

  int timeSubInSeconds(DateTime startTime, {bool fromThis = false}) {
    final _currentTime = fromThis ? this : DateTime.now();
    //? Time Def in seconds
    final int _sub = (_currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) ~/ 1000;
    return _sub;
  }

  Duration timeSub(DateTime startTime, {bool fromThis = false}) {
    final _currentTime = fromThis ? this : DateTime.now();
    //? Time Def in seconds
    final sub = (_currentTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) ~/ 1000;
    return Duration(milliseconds: sub);
  }
}
