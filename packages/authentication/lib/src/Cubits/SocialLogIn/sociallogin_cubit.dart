import 'dart:io';

import 'package:authentication/src/Models/models.dart';
import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import '../Login/login_cubit.dart';

typedef _SocialAuthCallback = Future<AuthResponse?> Function();

class SocialLogInCubit extends Cubit<LoginState> {
  SocialLogInCubit(this._repository) : super(LoginInitial());

  final AuthRepository _repository;

  void loginWithGoogle() async {
    _login(() => _repository.signInWithGoogle());
  }

  void loginWithFacebook() {
    _login(() => _repository.signInWithFacebook());
  }

  /// only available on iOS not android.
  void loginWithApple() async {
    if (!Platform.isIOS) return;
    _login(() => _repository.signInWithApple());
  }

  Future<bool> isAppleSignInAvailable() => _repository.isAppleSignInAvailable();

  Future<void> _login(_SocialAuthCallback cb) async {
    emit(LoginInProgress());
    try {
      final response = await cb.call();
      if (response == null) return emit(LoginInitial());
      final user = response.user;
      await _repository.saveUser(response);
      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailed(e));
    }
  }
}
