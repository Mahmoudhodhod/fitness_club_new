import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:utilities/utilities.dart';

import '_state.dart';

class SetNewPasswordCubit extends Cubit<ForgetPasswordState> {
  SetNewPasswordCubit(this._repository) : super(const ForgetPasswordState());

  final AuthRepository _repository;

  void setNewPassword(String password, String passwordConfirmation) async {
    emit(state.copyWith(state: ForgetPasswordS.loading));
    try {
      final token = await _repository.getUserToken();
      if (token == null) throw AppException('Token is NULL');

      final response = await _repository.setNewPassword(
        token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      await _repository.saveUserToken(response.token!, expireAt: response.expiresAt!);

      if (response.isNotVerified) {
        return emit(state.copyWith(
          state: ForgetPasswordS.loaded,
          isVerified: false,
          user: response.user,
        ));
      }

      await _repository.deleteUser();

      emit(state.copyWith(state: ForgetPasswordS.loaded));
    } catch (e) {
      emit(state.copyWith(state: ForgetPasswordS.failed, companion: e));
    }
  }
}
