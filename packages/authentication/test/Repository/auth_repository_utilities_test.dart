import 'package:authentication/src/Data/data.dart';
import 'package:authentication/src/Repository/SecureStorage/storage.dart';
import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preferences_utilities/preferences_utilities.dart';

class FakeAuthApiClient extends Fake implements AuthApiClient {}

main() {
  group("AuthRepository Utilities", () {
    const userToken = "__user_token__";

    late AuthRepository authRepository;
    late SecureStorage secureStorage;

    setUp(() {
      secureStorage = MockSecureStorage();

      authRepository = AuthRepository(
        client: FakeAuthApiClient(),
        secureStorage: secureStorage,
      );
    });

    group("User Token Operations", () {
      test("returns [null] when user token not saved", () {
        expect(authRepository.getUserToken(), completion(isNull));
      });
      test("saves user token to secure storage", () {
        expect(authRepository.saveUserToken(userToken), completes);
      });
      test("gets user token from secure storage", () async {
        await authRepository.saveUserToken(userToken);
        expect(authRepository.getUserToken(), completion("Bearer $userToken"));
      });
    });

    group("User login state", () {
      late BaseSharedPreferences sharedPreferences;

      setUp(() {
        sharedPreferences = MockSharedPrefrences();
        PreferencesUtilities.init(sharedPreferences);
      });

      tearDown(() {
        PreferencesUtilities.clearInstance();
      });

      test(
        "returns [false] when calling [isUserLoggedIn] "
        "by dafault",
        () {
          expect(authRepository.isUserLoggedIn, isFalse);
        },
      );

      test(
        "calls [userHasLoggedIn()] to save login state "
        "to be [True]",
        () {
          expect(authRepository.userLoggedIn(), completes);
          expect(authRepository.isUserLoggedIn, isTrue);
        },
      );
      test(
        "calls [userLoggedOut()] to save login state "
        "to be [False]",
        () {
          expect(authRepository.userLoggedOut(), completes);
          expect(authRepository.isUserLoggedIn, isFalse);
        },
      );
    });
  });
}

class MockSharedPrefrences extends BaseSharedPreferences {
  final Map<String, Object> _storage;

  MockSharedPrefrences() : _storage = {};

  @override
  Object? get(String key) {
    return _storage[key];
  }

  @override
  Future<bool> remove(String key) {
    final value = _storage.remove(key);
    return Future.value(value != null);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    _storage[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> clear() {
    _storage.clear();
    return Future.value(true);
  }
}

class MockSecureStorage extends SecureStorage {
  final Map<String, String> _storage;
  MockSecureStorage([Map<String, String>? values]) : _storage = values ?? {};
  @override
  Future<void> clear() {
    _storage.clear();
    return Future<void>.value();
  }

  @override
  Future<void> delete(String key) {
    _storage.remove(key);
    return Future<void>.value();
  }

  @override
  Future<String?> read(String key) {
    final value = _storage[key];
    return Future.value(value);
  }

  @override
  Future<void> write(String key, String value) {
    _storage[key] = value;
    return Future<void>.value();
  }
}
