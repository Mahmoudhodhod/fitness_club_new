import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'watchsubscriberinfochange_state.dart';

//TODO: [Important] implement logging out the user if his subscription ended.
class WatchSubscriberInfoChangeCubit extends Cubit<WatchSubscriberInfoChangeState> {
  final IAPController _iapController;
  late StreamController<SubscriptionInfo> _streamController;
  StreamSubscription<SubscriptionInfo>? _streamSubscription;

  WatchSubscriberInfoChangeCubit(this._iapController) : super(const WatchSubscriberInfoChangeInitial()) {
    _streamController = StreamController();
  }

  void watchSubscriptionInfo() {
    // final stream = _streamController.stream;
    // _streamSubscription = stream.listen((info) {
    //   // emit(SubscriptionInfoChanged(info));
    //   logger.i("Sub. Info has changed to #$info");
    // });

    // _iapController.listenToSubscriptionInfoUpdates((info) {
    //   _streamController.sink.add(info);
    // });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _streamController.close();
    return super.close();
  }
}
