import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilities/utilities.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit(this._repository) : super(const EmailVerificationState());

  final AuthRepository _repository;

  void verifyEmail(int code) async {
    emit(state.copyWith(state: EVState.loading));
    try {
      final response = await _repository.verifyEmail(code: code);
      final user = response.user;

      await _repository.saveUserToken(response.token!);
      await _repository.saveTokenExpireAt(response.expiresAt!);

      if (response.isNotVerified) throw AppException('invalid_code');

      await _repository.userLoggedIn();
      _repository.userChanged(user);

      emit(state.copyWith(state: EVState.loaded, user: user));
    } catch (e) {
      emit(state.copyWith(state: EVState.failed, companion: e));
    }
  }

  Future<void> resendCode() {
    return _repository.resendVerification();
  }
}
