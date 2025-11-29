///Returns the time difference between [from] and [to].
///
///The value is always positive.
///
int calculatTimeDifferenceInSeconds(DateTime from, {required DateTime to}) {
  final diffInMilliseconds = (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch).abs();
  final seconds = diffInMilliseconds ~/ 1000;
  return seconds;
}
