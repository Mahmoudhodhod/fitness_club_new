import 'dart:io';

import 'package:authentication/src/Repository/SecureStorage/storage.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:test/test.dart';

import 'package:authentication/src/Data/data.dart';
import 'package:authentication/src/Models/models.dart';
import 'package:authentication/src/Repository/auth_repository.dart';

class MockAuthApiClient extends Mock implements AuthApiClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockAuthUser extends Mock implements AuthUser {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockSharedPrefs extends Mock implements BaseSharedPreferences {}

class FakeMultipartFile extends Fake implements MultipartFile {}

class FakeUser extends Fake implements User {}

class FakeFile extends Fake implements File {}

//TODO: test get user data
main() {
  const userToken = "__user_token__";
  group("AuthRepository", () {
    late AuthApiClient apiClient;
    late AuthRepository authRepository;
    late AuthUser authUser;
    late AuthResponse authResponse;

    setUp(() {
      apiClient = MockAuthApiClient();
      authRepository = AuthRepository(client: apiClient);

      authUser = MockAuthUser();
      when(() => authUser.email).thenReturn("ahmed@mail.com");
      when(() => authUser.name).thenReturn("Ahmed");
      when(() => authUser.gender).thenReturn(Gender.male);
      when(() => authUser.password).thenReturn("p@ssword");
      when(() => authUser.passwordConfirmation).thenReturn("p@ssword");
      when(() => authUser.image).thenReturn(FakeFile());
      when(() => authUser.toFormData()).thenAnswer((_) async => FormData.fromMap({}));

      authResponse = MockAuthResponse();
      when(() => authResponse.token).thenReturn(userToken);
      when(() => authResponse.user).thenReturn(FakeUser());
    });

    group("Register with email and password", () {
      test(
        "calls register user with email and password",
        () {
          when(() => apiClient.registerWithEmailAndPassword(authUser)).thenAnswer((_) async => authResponse);

          expect(authRepository.registerWithEmailAndPassword(authUser), completion(isNotNull));

          verify(() => apiClient.registerWithEmailAndPassword(authUser)).called(1);
        },
      );
      test(
        "returns valid auth response when register",
        () {
          when(() => apiClient.registerWithEmailAndPassword(authUser)).thenAnswer(
            (_) async => authResponse,
          );
          expect(
            authRepository.registerWithEmailAndPassword(authUser),
            completion(authResponse),
          );
        },
      );

      test(
        "throws [RegisterFailure] when [RegisterAPIFailure] "
        "is thrown from Api client",
        () {
          when(() => apiClient.registerWithEmailAndPassword(authUser)).thenThrow(RegisterAPIFailure());
          expect(
            authRepository.registerWithEmailAndPassword(authUser),
            throwsA(isA<RegisterFailure>()),
          );
        },
      );
      test(
        "throws the same error when thrown in Api Client",
        () {
          final exp = Exception();
          when(() => apiClient.registerWithEmailAndPassword(authUser)).thenThrow(exp);
          expect(
            authRepository.registerWithEmailAndPassword(authUser),
            throwsA(exp),
          );
        },
      );
    });

    group("Login with email and password", () {
      test(
        "calls login user with email and password",
        () {
          when(() => apiClient.loginWithEmailAndPassword(authUser)).thenAnswer((_) async => authResponse);

          expect(authRepository.loginWithEmailAndPassword(authUser), completion(isNotNull));

          verify(() => apiClient.loginWithEmailAndPassword(authUser)).called(1);
        },
      );
      test(
        "returns valid auth response when register",
        () {
          when(() => apiClient.loginWithEmailAndPassword(authUser)).thenAnswer(
            (_) async => authResponse,
          );
          expect(
            authRepository.loginWithEmailAndPassword(authUser),
            completion(authResponse),
          );
        },
      );

      test(
        "throws [LoginFailure] when [LoginAPIFailure] "
        "is thrown from Api client",
        () {
          when(() => apiClient.loginWithEmailAndPassword(authUser)).thenThrow(LoginAPIFailure());
          expect(
            authRepository.loginWithEmailAndPassword(authUser),
            throwsA(isA<LoginFailure>()),
          );
        },
      );
      test(
        "throws the same error when thrown in Api Client",
        () {
          final exp = Exception();
          when(() => apiClient.loginWithEmailAndPassword(authUser)).thenThrow(exp);
          expect(
            authRepository.loginWithEmailAndPassword(authUser),
            throwsA(exp),
          );
        },
      );
    });
  });

  group("AuthRepository [social]", () {
    late AuthApiClient apiClient;
    late AuthRepository authRepository;

    late SecureStorage secureStorage;
    // late FacebookAuth facebookAuth;
    late GoogleSignIn googleSignIn;
    late BaseSharedPreferences sharedPreferences;

    late AuthUser authUser;
    late AuthResponse authResponse;

    setUp(() {
      apiClient = MockAuthApiClient();
      sharedPreferences = MockSharedPrefs();
      // facebookAuth = MockFacebookAuth();
      googleSignIn = MockGoogleSignIn();
      secureStorage = MockSecureStorage();

      PreferencesUtilities.init(sharedPreferences);
      authRepository = AuthRepository(
        client: apiClient,
        // facebookAuth: facebookAuth,
        googleSignIn: googleSignIn,
        secureStorage: secureStorage,
      );

      authUser = MockAuthUser();
      when(() => authUser.email).thenReturn("ahmed@mail.com");
      when(() => authUser.name).thenReturn("Ahmed");
      when(() => authUser.gender).thenReturn(Gender.male);
      when(() => authUser.password).thenReturn("p@ssword");
      when(() => authUser.passwordConfirmation).thenReturn("p@ssword");
      when(() => authUser.image).thenReturn(FakeFile());
      when(() => authUser.toFormData()).thenAnswer((_) async => FormData.fromMap({}));

      authResponse = MockAuthResponse();
      when(() => authResponse.token).thenReturn(userToken);
      when(() => authResponse.user).thenReturn(FakeUser());
    });

    test("logout()", () async {
      when(() => secureStorage.read(any())).thenAnswer((_) async => userToken);
      when(() => secureStorage.delete(any())).thenAnswer((_) async {});

      when(() => sharedPreferences.get(any())).thenAnswer((_) async => '');
      when(() => sharedPreferences.remove(any())).thenAnswer((_) async => true);

      when(() => apiClient.logout(any())).thenAnswer((_) async {});

      // when(() => facebookAuth.logOut()).thenAnswer((_) async {});

      when(() => googleSignIn.signOut()).thenAnswer((_) async {});

      await expectLater(authRepository.logout(), completion(isNot(throwsException)));

      verify(() => googleSignIn.signOut()).called(1);
      // verify(() => facebookAuth.logOut()).called(1);
      verify(() => apiClient.logout(userToken)).called(1);
    });
  });
}
