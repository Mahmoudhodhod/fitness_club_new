import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'fetchdata_state.dart';

class FetchDataCubit extends Cubit<FetchDataState> {
  FetchDataCubit(this._repository) : super(const FetchDataState()) {
    _userSub = _repository.user.listen((user) {
      if (user.isNotEmpty) _updateCurrentUserData(user);
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<User> _userSub;

  ///Fetches current user data from our api
  ///
  ///Updates current data.
  void fetchCurrentUserData() async {
    emit(state.copyWith(loadingState: LoadingState.loading));
    try {
      final user = await _repository.fetchUserData();
      _updateCurrentUserData(user);
    } catch (e) {
      emit(state.copyWith(loadingState: LoadingState.failed, e: e));
      // emit(state.copyWith(loadingState: LoadingState.loaded, user: User.empty));
    }
  }

  ///Updates current user data when user login or register.
  ///
  void _updateCurrentUserData(User user) {
    emit(state.copyWith(loadingState: LoadingState.loaded, user: user));
  }

  void listenToUserChange(ValueChanged<User> onChanged) {
    return _userSub.onData(onChanged);
  }
  
  void cleanCurrentUser() {
    emit(state.copyWith(loadingState: LoadingState.loaded, user: User.empty));
  }

  @override
  Future<void> close() {
    _userSub.cancel();
    return super.close();
  }
}
