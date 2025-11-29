// import 'package:authentication/authentication.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// class FakeAuthUser extends Fake implements AuthUser {}

// class MockUser extends Mock implements User {}

// class MockAuthResponse extends Mock implements AuthResponse {}

// //TODO: fix tests

// void main() {
//   group("RegisterCubit", () {
//     const userToken = "__user_token__";

//     late AuthRepository authRepository;

//     setUpAll(() {
//       registerFallbackValue<AuthUser>(FakeAuthUser());
//     });

//     setUp(() {
//       authRepository = MockAuthRepository();

//       when(() => authRepository.saveUserToken(any())).thenAnswer((_) async {});
//       when(() => authRepository.userLoggedIn()).thenAnswer((_) async {});
//     });

//     test("intial state is [RegisterInitial]", () {
//       expect(RegisterCubit(authRepository).state, RegisterInitial());
//     });

//     group("registerFormSubmitted", () {
//       final email = "ahmed@mail.com";
//       final password = "password";
//       final authUser = AuthUser(email: email, password: password);

//       late User user;
//       late AuthResponse authResponse;

//       setUp(() {
//         user = MockUser();
//         when(() => user.id).thenReturn(15);
//         when(() => user.name).thenReturn("Ahmed");
//         when(() => user.email).thenReturn("ahmed@mail.com");

//         authResponse = MockAuthResponse();
//         when(() => authResponse.user).thenReturn(user);
//         when(() => authResponse.token).thenReturn(userToken);

//         when(() => authRepository.loginWithEmailAndPassword(any())).thenAnswer((_) async => authResponse);
//       });

//       blocTest<RegisterCubit, RegisterState>(
//         "call register with correct user",
//         build: () => RegisterCubit(authRepository),
//         act: (cubit) => cubit.registerFormSubmitted(authUser),
//         verify: (bloc) {
//           verify(() => authRepository.registerWithEmailAndPassword(authUser)).called(1);
//         },
//       );

//       blocTest<RegisterCubit, RegisterState>(
//         "emits [RegisterInProgress, RegisterSuccess] "
//         "when register successed",
//         build: () => RegisterCubit(authRepository),
//         act: (cubit) => cubit.registerFormSubmitted(authUser),
//         expect: () => [
//           RegisterInProgress(),
//           RegisterSuccess(user: user),
//         ],
//       );

//       blocTest<RegisterCubit, RegisterState>(
//         "saves user access token when login successed",
//         build: () => RegisterCubit(authRepository),
//         act: (cubit) => cubit.registerFormSubmitted(authUser),
//         verify: (_) {
//           verify(() => authRepository.saveUserToken(userToken)).called(1);
//         },
//       );

//       blocTest<RegisterCubit, RegisterState>(
//         "emits [RegisterInProgress, RegisterFailed] "
//         "when register fails",
//         build: () {
//           when(() => authRepository.registerWithEmailAndPassword(any())).thenThrow(Exception());
//           return RegisterCubit(authRepository);
//         },
//         act: (cubit) => cubit.registerFormSubmitted(authUser),
//         expect: () => [
//           RegisterInProgress(),
//           RegisterFailed(),
//         ],
//       );
//     });
//   });
// }
