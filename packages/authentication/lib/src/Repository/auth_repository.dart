import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:utilities/utilities.dart';

import '../../authentication.dart';

part 'data_update_extension.dart';
part 'forget_password_extension.dart';
part 'social_auth_extension.dart';
part 'token_data_extension.dart';

///Thrown when user register process failed.
///
class RegisterFailure implements Exception {}

///Thrown when user login process failed.
///
class LoginFailure implements Exception {}

class NoCurrentUser implements Exception {
  @override
  String toString() => 'No Current User';
}

class AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorage _secureStorage;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final StreamController<User> _streamController;

  AuthRepository({
    required AuthApiClient client,
    SecureStorage? secureStorage,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  })  : _apiClient = client,
        _secureStorage = secureStorage ?? AppSecureStorage(),
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _streamController = StreamController.broadcast();

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _streamController.stream.asBroadcastStream();
  }

  ///Triggers user changing state.
  ///
  void userChanged(User? user) {
    _streamController.sink.add(user ?? User.empty);
  }

  Future<AuthResponse> registerWithEmailAndPassword(AuthUser user) async {
    try {
      final _result = await _apiClient.registerWithEmailAndPassword(user);
      return _result;
    } on RegisterAPIFailure {
      throw RegisterFailure();
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> loginWithEmailAndPassword(AuthUser user) async {
    try {
      final _result = await _apiClient.loginWithEmailAndPassword(user);
      return _result;
    } on LoginAPIFailure {
      throw LoginFailure();
    }
  }

  ///Logout the current logged in user.
  ///
  ///perform logout from all providers if any.
  ///
  ///* [force] forces the logout action even if the current user's token is [null].
  ///
  Future<void> logout({bool force = false}) async {
    String? token = await this.getUserToken();
    if (!force && token == null) {
      deleteUserData();

      throw NoCurrentUser();
    }

    await Future.wait([
      if (token != null) _apiClient.logout(token),
      _facebookAuth.logOut(),
      _googleSignIn.signOut(),
      deleteUserData(),
    ]);
    return Future<void>.value();
  }

  Future<void> deleteUser() async {
    final String? token = await this.getUserToken();
    if (token == null) throw NoCurrentUser();
    await _apiClient.deleteUser(token);
    await deleteUserData();
  }

  Future<User> fetchUserData() async {
    final token = await this.getUserToken();
    if (kDebugMode) {
      log(token ?? 'NO TOKEN');
    }
    if (token == null) throw NoCurrentUser();
    // if (token == null) return User.empty;
    final _result = await _apiClient.fetchUserData(token);
    return _result.user;
  }

  Future<AuthResponse> verifyEmail({required int code}) async {
    final token = await this.getUserToken();
    if (token == null) throw NoCurrentUser();

    final _result = await _apiClient.verifyEmail(token, code: code);
    return _result;
  }

  Future<void> resendVerification() async {
    final token = await this.getUserToken();
    if (token == null) throw NoCurrentUser();

    return _apiClient.resendVerificationCode(token);
  }

  void dispose() {
    _streamController.close();
  }
}
