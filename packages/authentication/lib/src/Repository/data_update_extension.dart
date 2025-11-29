part of 'auth_repository.dart';

extension UpdateData on AuthRepository {
  Future<User> updateUserData(UserUpdate user) async {
    final token = await getUserToken();
    if (token == null) throw NoCurrentUser();

    final _result = await _apiClient.updateData(token, user: user);
    return _result.user;
  }

  Future<void> updateUserPassword(PasswordUpdate password) async {
    final token = await getUserToken();
    if (token == null) throw NoCurrentUser();

    return await _apiClient.updateUserPassword(token, password: password);
  }

  Future<void> updateFCMToken({required String fcmToken}) async {
    final token = await getUserToken();
    if (token == null) return;

    await _apiClient.updateFCMToken(token, fcmToken: fcmToken);
  }

  ///Delete all current user's local preferences data.
  ///
  Future<void> deleteUserData() async {
    await deleteUser();
    await PreferencesUtilities.instance!.clearAll();
    await _secureStorage.clear();
  }

  ///Delete current user's data
  ///
  Future<void> deleteUser() async {
    await removeToken();
    await userLoggedOut();
    userChanged(null);
  }

  ///Saves the new user data
  ///
  Future<void> saveUser(AuthResponse response) async {
    if (response.token != null) await saveUserToken(response.token!);
    if (response.expiresAt != null) await saveTokenExpireAt(response.expiresAt!);
    await userLoggedIn();
    userChanged(response.user);
  }
}
