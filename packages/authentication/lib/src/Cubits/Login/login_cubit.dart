import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:authentication/src/Models/models.dart';
import 'package:authentication/src/Repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  ///Perform login with user data.
  ///
  void loginFormSubmitted(AuthUser authUser) async {
    emit(LoginInProgress());
    try {
      final response = await _repository.loginWithEmailAndPassword(authUser);
      final user = response.user;

      await _repository.saveUserToken(response.token!);
      await _repository.saveTokenExpireAt(response.expiresAt!);

      if (response.isNotVerified) {
        return emit(LoginSuccess(user: user, isVerified: false));
      } else {
        await _repository.userLoggedIn();
        _repository.userChanged(user);

        emit(LoginSuccess(user: user));
      }
    } catch (e) {
      // final isTokenExpired = _repository.isTokenExpired();
      // if (isTokenExpired) {
      //   emit(LoginFailedWithUnauthorizedUser());
      // } else {
      emit(LoginFailed(e));
      // }
    }
  }
}
