// import 'package:bloc_test/bloc_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// import 'package:authentication/authentication.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// class MockFetchDataCubit extends Mock implements FetchDataCubit {}

// class FakeAuthUser extends Fake implements AuthUser {}

// class MockUser extends Mock implements User {}

// class MockAuthResponse extends Mock implements AuthResponse {}

// void main() {
//   group("LogoutCubit", () {
//     late AuthRepository authRepository;
//     late FetchDataCubit fetchDataCubit;

//     final Exception exp = Exception('Oops!');

//     setUpAll(() {
//       registerFallbackValue<AuthUser>(FakeAuthUser());
//     });

//     setUp(() {
//       authRepository = MockAuthRepository();
//       fetchDataCubit = MockFetchDataCubit();

//       when(() => authRepository.logout()).thenAnswer((_) async {});
//       when(() => authRepository.isUserLoggedIn()).thenReturn(true);
//     });

//     test("intial state is [LoginInitial]", () {
//       expect(LogoutCubit(authRepository, fetchDataCubit).state, LogoutInitial());
//     });

//     group('logoutSubmitted', () {
//       blocTest<LogoutCubit, LogoutState>(
//         "call repo logout()",
//         build: () => LogoutCubit(authRepository, fetchDataCubit),
//         act: (cubit) => cubit.logoutSubmitted(),
//         verify: (_) {
//           verify(() => authRepository.logout()).called(1);
//         },
//       );

//       blocTest<LogoutCubit, LogoutState>(
//         "never calls logout() when user not signed in",
//         build: () {
//           when(() => authRepository.isUserLoggedIn()).thenReturn(false);
//           return LogoutCubit(authRepository, fetchDataCubit);
//         },
//         act: (cubit) => cubit.logoutSubmitted(),
//         verify: (_) {
//           verifyNever(() => authRepository.logout());
//         },
//       );

//       blocTest<LogoutCubit, LogoutState>(
//         "emits [LogoutInProgress, LogoutSucceded] "
//         "when logout successed",
//         build: () => LogoutCubit(authRepository, fetchDataCubit),
//         act: (cubit) => cubit.logoutSubmitted(),
//         expect: () => [
//           LogoutInProgress(),
//           LogoutSucceeded(),
//         ],
//       );

//       blocTest<LogoutCubit, LogoutState>(
//         "emits [LogoutInProgress, LogoutFailed] "
//         "when logout failed",
//         build: () {
//           when(() => authRepository.logout()).thenThrow(exp);
//           return LogoutCubit(authRepository, fetchDataCubit);
//         },
//         act: (cubit) => cubit.logoutSubmitted(),
//         expect: () => [
//           LogoutInProgress(),
//           LogoutFailed(exp),
//         ],
//       );
//     });
//   });
// }
