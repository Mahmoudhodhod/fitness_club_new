import 'dart:developer';

import 'package:authentication/src/Helpers/helper.dart';
import 'package:authentication/src/Helpers/network.dart';
import 'package:authentication/src/Models/models.dart';
import 'package:dio/dio.dart';
import 'package:utilities/utilities.dart';

///Thrown when register fails.
///
class RegisterAPIFailure implements Exception {}

///Thrown when login fails.
///
class LoginAPIFailure implements Exception {}

class FetchUserDataFailure implements Exception {}

class UpdateUserDataFailure implements Exception {}

class UpdateUserPasswordFailure implements Exception {}

class LogoutFailure implements Exception {}

class UserDeletionFailure implements Exception {}

class AuthApiClient {
  final Dio _client;

  ///Creates Auth client to handle api calls and responses.
  ///
  AuthApiClient({Dio? client}) : _client = client ?? Dio();

  ///Register new user using his email and password.
  ///
  ///user details can be based in [user].
  ///
  Future<AuthResponse> registerWithEmailAndPassword(AuthUser user) async {
    final uri = AuthNetworking.emailAndPasswordRegisterUri;
    log('registerWithEmailAndPassword $uri');
    log('commonOptions() ${commonOptions().extra}');
    log('data ${await user.toJson()}');
    final _response = await _client.postUri(
      uri,
      options: commonOptions(),
      data: await user.toFormData(),
    );
    // if (_response.statusCode != 200) throw RegisterAPIFailure();
    final _body = _response.data;
    return AuthResponse.fromJson(_body);
  }

  ///login old user using his email and password.
  ///
  Future<AuthResponse> loginWithEmailAndPassword(AuthUser user) async {
    final uri = AuthNetworking.emailAndPasswordLoginUri;
    final _response = await _client.postUri(
      uri,
      options: commonOptions(),
      data: {"email": user.email, "password": user.password},
    );
    log('_response_response_response ${_response}');
    if (_response.statusCode != 200) throw LoginAPIFailure();
    final _body = _response.data;
    return AuthResponse.fromJson(_body);
  }

  ///Fetches current user data using his [token].
  ///
  Future<AuthResponse> fetchUserData(String token) async {
    try {
      final uri = AuthNetworking.userDataUri;
      final _response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (_response.statusCode != 200) throw FetchUserDataFailure();
      final _body = _response.data;
      return AuthResponse.fromJson(_body);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  ///Updates current user data with [token].
  ///
  ///* [user] is the new user update model.
  Future<AuthResponse> updateData(String token,
      {required UserUpdate user}) async {
    try {
      final uri = AuthNetworking.updateUserData.addQueryParams(const [
        const QueryParam(param: '_method', value: 'PUT'),
      ]);
      final userFromData = await user.getUpdatedData();
      final _response = await _client.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: userFromData,
      );
      if (_response.statusCode != 200) throw UpdateUserDataFailure();
      final _body = _response.data;
      return AuthResponse.fromJson(_body);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updateFCMToken(String token, {required String fcmToken}) async {
    final uri = AuthNetworking.updateUserFCMToken;
    await _client.postUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
      data: {"mobile_token": fcmToken},
    );
  }

  ///Updates current user data with [token].
  ///
  ///* [password] is the new user's password.
  Future<void> updateUserPassword(String token,
      {required PasswordUpdate password}) async {
    final uri = AuthNetworking.updateUserPassword;
    final _response = await _client.postUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
      data: password.toJson(),
    );
    if (_response.statusCode != 200) throw UpdateUserPasswordFailure();
    return Future<void>.value();
  }

  ///Logout current user with [token].
  ///
  Future<void> logout(String token) async {
    final uri = AuthNetworking.userLogout;
    final _response = await _client.postUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
    );
    if (_response.statusCode != 200) throw LogoutFailure();
    return Future<void>.value();
  }

  /// Delete current user with [token].
  ///
  Future<void> deleteUser(String token) async {
    final _response = await _client.deleteUri(
      AuthNetworking.deleteUserUri,
      options: commonOptionsWithAuthHeader(token),
    );
    if (_response.statusCode != 200) throw UserDeletionFailure();
    return Future<void>.value();
  }

  ///Sign in with credentials.
  ///
  ///Used when signing with Google and Facebook.
  ///
  Future<AuthResponse> signInWithCredential(OAuthCredential credential) async {
    final data = credential.toJson();
    final response = await _client.postUri(
      AuthNetworking.signInWithProviderUri,
      options: commonOptions(
        Options(headers: credential.requestHeaders),
      ),
      data: data,
    );
    final body = response.data;
    return AuthResponse.fromJson(body);
  }

  /// Sign in with Apple.
  ///
  Future<AuthResponse> signInWithApple(OAuthCredential credential) async {
    final name = credential.meta['name'];
    final data = {
      'auth_code': credential.token,
      if (name != null) 'name': name,
    };
    final response = await _client.postUri(
      AuthNetworking.signInWithAppleUri,
      options: commonOptions(),
      data: data,
    );
    log('responseresponseresponseresponse $response');
    final body = response.data;
    return AuthResponse.fromJson(body);
  }

  Future<AuthResponse> verifyEmail(String token, {required int code}) async {
    final uri = AuthNetworking.verificationUri;
    final response = await _client.postUri(
      uri,
      options: commonOptionsWithAuthHeader(token),
      data: {'verification_code': code},
    );
    if (response.statusCode != 200) throw AppException();
    final body = response.data;
    return AuthResponse.fromJson(body);
  }

  Future<void> resendVerificationCode(String token) async {
    try {
      final uri = AuthNetworking.resendVerificationUri;
      final response = await _client.getUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
      );
      if (response.statusCode != 200) throw AppException();
      return Future<void>.value();
    } on DioException catch (e) {
      return Future.error(e);
    }
  }
}

extension ForgetPassword on AuthApiClient {
  Future<void> forgetPassword(String email) async {
    final uri = AuthNetworking.forgetPasswordUri;
    final response = await _client.postUri(
      uri,
      options: commonOptions(),
      data: {'email': email},
    );
    if (response.statusCode != 200) throw AppException();
    return Future<void>.value();
  }

  Future<AuthResponse> forgetPasswordVerification(
      {required String email, required int code}) async {
    try {
      final uri = AuthNetworking.forgetPasswordVerificationUri;
      final response = await _client.postUri(
        uri,
        options: commonOptions(),
        data: {'email': email, 'forgot_password_code': code},
      );
      if (response.statusCode != 200) throw AppException();
      final body = response.data;
      return AuthResponse.fromJson(body);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }

  Future<AuthResponse> setNewPassword(
    String token, {
    required String password,
    required String passwordCofirmation,
  }) async {
    try {
      final uri = AuthNetworking.setNewPasswordUri;
      final response = await _client.postUri(
        uri,
        options: commonOptionsWithAuthHeader(token),
        data: {
          'password': password,
          'password_confirmation': passwordCofirmation
        },
      );
      if (response.statusCode != 200) throw AppException();
      final body = response.data;
      return AuthResponse.fromJson(body);
    } on DioException catch (e) {
      return Future.error(e);
    }
  }
}
