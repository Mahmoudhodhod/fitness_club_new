import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';

import '_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._repository) : super(const ForgetPasswordState());

  final AuthRepository _repository;

  void forgetPassword(String email) async {
    emit(state.copyWith(state: ForgetPasswordS.loading));
    try {
      await _repository.forgetPassword(email);
      emit(state.copyWith(state: ForgetPasswordS.loaded));
    } catch (e) {
      emit(state.copyWith(state: ForgetPasswordS.failed, companion: e));
    }
  }
}
