import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:authentication/authentication.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeAuthUser extends Fake implements AuthUser {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  const userToken = "__user_token__";
  group("LoginCubit", () {
    late AuthRepository authRepository;

    // setUpAll(() {
    //   registerFallbackValue<AuthUser>(FakeAuthUser());
    // });

    setUp(() {
      authRepository = MockAuthRepository();

      when(() => authRepository.saveUserToken(any())).thenAnswer((_) async {});
      when(() => authRepository.userLoggedIn()).thenAnswer((_) async {});
    });

    test("intial state is [LoginInitial]", () {
      expect(LoginCubit(authRepository).state, LoginInitial());
    });

    group("registerFormSubmitted", () {
      final email = "ahmed@mail.com";
      final password = "password";
      final authUser = AuthUser(email: email, password: password);

      late User user;
      late AuthResponse authResponse;

      setUp(() {
        user = MockUser();
        when(() => user.id).thenReturn(15);
        when(() => user.name).thenReturn("Ahmed");
        when(() => user.email).thenReturn("ahmed@mail.com");

        authResponse = MockAuthResponse();
        when(() => authResponse.user).thenReturn(user);
        when(() => authResponse.token).thenReturn(userToken);

        when(() => authRepository.loginWithEmailAndPassword(any()))
            .thenAnswer((_) async => authResponse);
      });

      blocTest<LoginCubit, LoginState>(
        "call login with correct user",
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.loginFormSubmitted(authUser),
        verify: (_) {
          verify(() => authRepository.loginWithEmailAndPassword(authUser))
              .called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        "emits [LoginInProgress, LoginSuccess] "
        "when login successed",
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.loginFormSubmitted(authUser),
        expect: () => [
          LoginInProgress(),
          LoginSuccess(user: user),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        "saves user access token when login successed",
        build: () => LoginCubit(authRepository),
        act: (cubit) => cubit.loginFormSubmitted(authUser),
        verify: (_) {
          verify(() => authRepository.saveUserToken(userToken)).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        "emits [LoginInProgress, LoginFailed] "
        "when login fails",
        build: () {
          when(() => authRepository.loginWithEmailAndPassword(any()))
              .thenThrow(LoginFailed());
          return LoginCubit(authRepository);
        },
        act: (cubit) => cubit.loginFormSubmitted(authUser),
        expect: () => [
          LoginInProgress(),
          LoginFailed(LoginFailed()),
        ],
      );
    });
  });
}
