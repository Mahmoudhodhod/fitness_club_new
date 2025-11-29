import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///Device secure storage base interface.
///
abstract class SecureStorage {
  const SecureStorage();

  ///Deletes associated value for the given [key].
  Future<void> delete(String key);

  ///Decrypts and returns the value for the given [key] or null if [key] is not in the storage.
  Future<String?> read(String key);

  ///Encrypts and saves the [key] with the given [value].
  Future<void> write(String key, String value);

  ///Clear all keys with associated values.
  Future<void> clear();
}

///Returns app secure storage impelementation to save critical values
///to the current device Secure Storage.
class AppSecureStorage extends SecureStorage {
  final FlutterSecureStorage _secureStorage;
  const AppSecureStorage() : _secureStorage = const FlutterSecureStorage();
  @override
  Future<void> clear() async {
    return _secureStorage.deleteAll();
  }

  @override
  Future<void> delete(String key) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<String?> read(String key) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }
}
