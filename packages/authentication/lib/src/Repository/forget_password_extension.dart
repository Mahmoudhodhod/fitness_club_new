part of 'auth_repository.dart';

extension ForgetPasswordR on AuthRepository {
  Future<void> forgetPassword(String email) {
    return _apiClient.forgetPassword(email);
  }

  Future<AuthResponse> forgetPasswordVerification({required String email, required int code}) {
    return _apiClient.forgetPasswordVerification(email: email, code: code);
  }

  Future<AuthResponse> setNewPassword(
    String token, {
    required String password,
    required String passwordConfirmation,
  }) {
    return _apiClient.setNewPassword(
      token,
      password: password,
      passwordCofirmation: passwordConfirmation,
    );
  }
}
