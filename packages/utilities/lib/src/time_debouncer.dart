import 'dart:async' show StreamController, StreamSubscription;

import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:rxdart/rxdart.dart' show DebounceExtensions;

//TODO: test

const kTimeDenouncerDuration = Duration(milliseconds: 100);

///Creates a very simple api to impelement a listenable controller debouncer.
///which can be used easily without using any StreamControllers to help captcher the
///data stream and process it.
///
class TimeDebouncer<T> {
  ///The debounce duration, defaults to `Duration(milliseconds: 100)`.
  ///
  final Duration duration;

  ///Triggered when the debounce stream is triggered with the associated
  ///duration.
  ///
  final ValueChanged<T> onChanged;

  ///Creates a very simple api to impelement a listenable controller debouncer.
  ///
  TimeDebouncer({
    required this.onChanged,
    this.duration = kTimeDenouncerDuration,
  }) {
    _streamController = StreamController<T>();
  }

  late StreamController<T> _streamController;
  Stream<T> get _stream => _streamController.stream.asBroadcastStream();
  StreamSubscription<T>? _streamSubscription;

  /// Transforms a [Stream] so that will only emit items from the source
  /// sequence whenever the time span defined by [duration] passes, without the
  /// source sequence emitting another item.
  void add(T value) {
    _streamController.sink.add(value);
    _streamSubscription ??= _stream.debounceTime(duration).listen((value) {
      onChanged.call(value);
    });
  }

  ///Disposes all internal controller and streams.
  ///
  ///Using [add(T)] after calling this method throws an exception.
  ///
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _streamController.close();
  }
}
