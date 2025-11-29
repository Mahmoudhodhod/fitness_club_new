part of 'auth_repository.dart';

class ChangingUserLoginStateFailure implements Exception {}

extension UserToken on AuthRepository {
  static const _userTokenKey = "__token_key__";
  static const _isLoggedIn = "__is_logged_in__";
  static const _expireAt = "__exprite_at__";

  ///Is there current user signed in.
  ///
  bool isUserLoggedIn() {
    return PreferencesUtilities.instance!.getValueWithKey(_isLoggedIn) ?? false;
  }

  ///Trigger user login event to save the current auth state.
  ///
  Future<void> userLoggedIn() async {
    final result = await PreferencesUtilities.instance!
        .saveValueWithKey<bool>(_isLoggedIn, true);
    if (!result) throw ChangingUserLoginStateFailure();
    return Future<void>.value();
  }

  ///Trigger user logged out event to save the current auth state.
  ///
  Future<void> userLoggedOut() async {
    final result =
        await PreferencesUtilities.instance!.removeValueWithKey(_isLoggedIn);
    if (!result) throw ChangingUserLoginStateFailure();
    return Future<void>.value();
  }

  ///Deletes user's token to secure device storage.
  ///
  Future<void> removeToken() async {
    await _secureStorage.delete(_userTokenKey);
    await PreferencesUtilities.instance!.removeValueWithKey(_expireAt);
  }

  ///Save user's token to secure device storage.
  ///
  Future<void> saveUserToken(String token,
      {String? type, DateTime? expireAt}) async {
    await _secureStorage.write(_userTokenKey, "${type ?? 'Bearer'} $token");
    if (expireAt != null) await saveTokenExpireAt(expireAt);
    return Future<void>.value();
  }

  ///Reads user's token in device secure storage.
  ///
  Future<String?> getUserToken() async {
    print('tokeeeen ${await _secureStorage.read(_userTokenKey)}');
    return await _secureStorage.read(_userTokenKey);
  }

  ///Getting the current user token state if the token is still valid or not to be used.
  ///
  bool isTokenExpired() {
    final result =
        PreferencesUtilities.instance!.getValueWithKey<String>(_expireAt);
    if (result == null) return true;
    final expireAt = DateTime.tryParse(result);
    if (expireAt == null) return true;
    return DateTime.now().isAfter(expireAt);
  }

  ///Saving the current user token expiration date to local storage.
  ///
  Future<void> saveTokenExpireAt(DateTime expireAt) async {
    final result =
        await PreferencesUtilities.instance!.saveValueWithKey<String>(
      _expireAt,
      expireAt.toIso8601String(),
    );
    if (!result) const AppException('Error happened while saving `expire_at`.');
  }
}
