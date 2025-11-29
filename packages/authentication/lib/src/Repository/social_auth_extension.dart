part of 'auth_repository.dart';

class SocialLoginFailure implements Exception {
  final String message;
  final String error;
  const SocialLoginFailure(this.message, this.error);
  @override
  String toString() => {'message': message, 'error': error}.toString();
}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure extends SocialLoginFailure {
  const LogInWithGoogleFailure(String message, String error)
      : super(message, error);
}

/// Thrown during the sign in with facebook process if a failure occurs.
class LogInWithFacebookFailure extends SocialLoginFailure {
  const LogInWithFacebookFailure(String message, String error)
      : super(message, error);
}

bool isSocialLoginFailure(Object? e) {
  return e is SocialLoginFailure ||
      e is LogInWithGoogleFailure ||
      e is LogInWithFacebookFailure;
}

/// Thrown during the sign in with Apple process if a failure occurs.
class LogInWithAppleFailure implements Exception {}

/// Sign in with Apple is available on:
/// - iOS 13 and higher
/// - macOS 10.15 and higher
/// - Android
///
class SignInWithAppleNotSupported implements Exception {}

extension Social on AuthRepository {
  Future<AuthResponse?> signInWithGoogle() async {
    final token = await this.getUserToken();
    if (token != null) return null;
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken ?? "");
      debugPrint("GOOGLE TOKEN: ${googleAuth.accessToken ?? "-"}");
      return await _apiClient.signInWithCredential(credential);
    } on DioError catch (e) {
      final data = e.response?.data ?? {};
      final message = data["message"] ?? "Something went wrong";
      final error = data["error"] ?? "UNKNOWN_ERROR";
      throw LogInWithGoogleFailure(message, error);
    } catch (e) {
      debugPrint(e.toString());
      throw LogInWithGoogleFailure("INTERNAL_ERROR", "Something went wrong");
    }
  }

  Future<AuthResponse?> signInWithFacebook() async {
    final token = await this.getUserToken();
    if (token != null) return null;
    try {
      final authResult = await _facebookAuth.login();
      if (authResult.status == LoginStatus.cancelled) return null;
      if (authResult.status == LoginStatus.failed) {
        throw AppException(
            "Facebook login failed with message ${authResult.message}");
      }
      final credential = FacebookAuthProvider.credential(
          accessToken: authResult.accessToken?.token ?? "");
      log(authResult.accessToken?.token ?? "-");
      return await _apiClient.signInWithCredential(credential);
    } on DioError catch (e) {
      final data = e.response?.data ?? {};
      final message = data["message"] ?? "Something went wrong";
      final error = data["error"] ?? "UNKNOWN_ERROR";
      throw LogInWithFacebookFailure(message, error);
    } catch (e) {
      throw LogInWithFacebookFailure("INTERNAL_ERROR", "Something went wrong");
    }
  }

  @visibleForTesting
  Future<void> logoutFromFacebook() => _facebookAuth.logOut();

  Future<bool> isAppleSignInAvailable() => SignInWithApple.isAvailable();

  Future<AuthResponse?> signInWithApple() async {
    final token = await this.getUserToken();
    if (token != null) return null;
    final isAvailable = await isAppleSignInAvailable();
    if (!isAvailable) throw SignInWithAppleNotSupported();
    try {
      final creds = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final credential = AppleAuthProvider.credential(
        code: creds.authorizationCode,
        name: "any",
      );
      return _apiClient.signInWithApple(credential);

      // final googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) return null;
      // final googleAuth = await googleUser.authentication;
      // final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth.accessToken ?? "");
      // debugPrint("GOOGLE TOKEN: ${googleAuth.accessToken ?? "-"}");
      // return await _apiClient.signInWithCredential(credential);
    } on SignInWithAppleAuthorizationException catch (e) {
      return _handleAppleError(e);
    } on SignInWithAppleNotSupportedException {
      throw SignInWithAppleNotSupported();
    } catch (e) {
      throw LogInWithAppleFailure();
    }
  }

  @visibleForTesting
  Future<void> logoutFromGoogle() => _googleSignIn.signOut();

  Null _handleAppleError(SignInWithAppleAuthorizationException e) {
    switch (e.code) {
      case AuthorizationErrorCode.failed:
      case AuthorizationErrorCode.invalidResponse:
        throw e;
      default:
        return null;
    }
  }
}
