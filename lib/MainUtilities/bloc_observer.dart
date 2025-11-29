import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log(event.toString(), name: bloc.toStr(), level: 2);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log(change.toString(), name: bloc.toStr(), level: 2);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(bloc.toString(), name: bloc.toStr(), level: 2);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log("Bloc Error", name: bloc.toStr(), level: 4, error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

extension on BlocBase {
  String toStr() {
    return toString().split("Instance of").last.split("'")[1];
  }
}
