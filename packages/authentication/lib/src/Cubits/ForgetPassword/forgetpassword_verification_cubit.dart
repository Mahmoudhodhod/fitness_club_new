import 'dart:developer';

import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

import '_state.dart';

class ForgetPasswordVerfCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordVerfCubit(this._repository) : super(const ForgetPasswordState());

  final AuthRepository _repository;

  void forgetPasswordVerification(String email, int code) async {
    emit(state.copyWith(state: ForgetPasswordS.loading));
    try {
      final response = await _repository.forgetPasswordVerification(email: email, code: code);
      try {
        await _repository.saveUserToken(response.token!, expireAt: response.expiresAt!);
      } catch (e, stacktrace) {
        log("Error while sending forget password request", error: e, stackTrace: stacktrace);
      }
      emit(state.copyWith(state: ForgetPasswordS.loaded));
    } catch (e) {
      emit(state.copyWith(state: ForgetPasswordS.failed, companion: e));
    }
  }
}
