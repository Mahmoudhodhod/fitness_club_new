import 'package:utilities/utilities.dart';

class AuthNetworking {
  AuthNetworking._();
  static Uri _generalUri = Network.webSiteUri.addSegment("/general");
  static Uri _authUri = _generalUri.addSegment("/auth");

  static Uri userDataUri = _authUri.addSegment("/user");
  static Uri emailAndPasswordRegisterUri = _authUri.addSegment("/register");
  static Uri emailAndPasswordLoginUri = _authUri.addSegment("/login");
  static Uri updateUserData = _authUri.addSegment("/update-user");
  static Uri deleteUserUri = _authUri.addSegment("/delete-user");
  static Uri updateUserFCMToken = _authUri.addSegment("/fcm-token");
  static Uri updateUserPassword = _authUri.addSegment("/change-password");
  static Uri userLogout = _authUri.addSegment("/logout");
  static Uri signInWithProviderUri = _authUri.addSegment('/login-or-register-with-provider');
  static Uri signInWithAppleUri = _authUri.addSegment('/login-or-register-with-apple');

  static Uri verificationUri = _authUri.addSegment('/verification');
  static Uri resendVerificationUri = _authUri.addSegment('/resend_verification');

  static Uri forgetPasswordUri = _authUri.addSegment('/forgot-password');
  static Uri forgetPasswordVerificationUri = forgetPasswordUri.addSegment('/verification');
  static Uri setNewPasswordUri = forgetPasswordUri.addSegment('/set-new-password');
}
