// import 'dart:io';

// import 'package:authentication/authentication.dart';
// import 'package:dio/dio.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// /*
// ? - register user using normal auth and Google sing in
// * register normal.
// * register via Google.

// ? - login user using normal auth and Google sign in 

// ?- get current user data

// ?- update user data -> can be updated one a time.

// ?- update user password 
// */

// class MockDio extends Mock implements Dio {}

// class MockResponse extends Mock implements Response {}

// class MockAuthUser extends Mock implements AuthUser {}

// class MockFile extends Mock implements File {}

// class MockMultipartFile extends Mock implements MultipartFile {}

// class FakeUri extends Fake implements Uri {}

// class FakeFormData extends Fake implements FormData {}

// class FakeOptions extends Fake implements Options {}

// class FakeFile extends Fake implements File {}

// final _registerUri = Uri.parse("https://thecoach.tk/api/user/register");
// final _loginUri = Uri.parse("https://thecoach.tk/api/user/login");
// final _userDataUri = Uri.parse("https://thecoach.tk/api/user/data");

// void main() {
//   const dummyToken = "user_access_token";
//   const userResponse = {
//     "id": 15,
//     "name": "Mohamed Gamal",
//     "email": "a@mail.com",
//     "email_verified_at": null,
//     "gender": "male",
//     "image": "https://thecoach.tk/storage/app/public/profile/external-content.duckduckgo-6_1628933694.jpg",
//     "provider": "authentication",
//     "created_at": "2021-08-14T09:34:54.000000Z",
//     "updated_at": "2021-08-14T09:34:54.000000Z"
//   };
//   const dummyResponse = {
//     "success": true,
//     "user": userResponse,
//     "token": dummyToken,
//   };
//   group("AuthApiClient", () {
//     late Dio dioClient;
//     late AuthApiClient authApiClient;
//     late AuthUser authUser;
//     late Response validResponse;
//     late Response invalidResponse;

//     setUpAll(() {
//       registerFallbackValue<Uri>(FakeUri());
//       registerFallbackValue<FormData>(FakeFormData());
//       registerFallbackValue<Options>(FakeOptions());
//     });

//     setUp(() {
//       dioClient = MockDio();
//       authApiClient = AuthApiClient(client: dioClient);

//       authUser = MockAuthUser();
//       when(() => authUser.email).thenReturn("ahmed@mail.com");
//       when(() => authUser.name).thenReturn("Ahmed");
//       when(() => authUser.gender).thenReturn(Gender.male);
//       when(() => authUser.password).thenReturn("p@ssword");
//       when(() => authUser.passwordConfirmation).thenReturn("p@ssword");
//       when(() => authUser.image).thenReturn(FakeFile());
//       when(() => authUser.toFormData()).thenAnswer((_) async => FormData.fromMap({}));

//       validResponse = MockResponse();
//       when(() => validResponse.data).thenReturn(dummyResponse);
//       when(() => validResponse.statusCode).thenReturn(200);
//       when(() => validResponse.statusMessage).thenReturn("success");

//       invalidResponse = MockResponse();
//       when(() => invalidResponse.data).thenReturn({});
//       when(() => invalidResponse.statusCode).thenReturn(400);
//       when(() => invalidResponse.statusMessage).thenReturn("invalid request");
//     });

//     test("constructing [AuthApiClient] deosn't throw", () {
//       expect(AuthApiClient(), isNot(throwsException));
//     });

//     group("Normal Auth [Register-Login]", () {
//       setUp(() {
//         when(
//           () => dioClient.postUri(any(), options: any(named: "options"), data: any(named: "data")),
//         ).thenAnswer((_) async => validResponse);
//       });

//       group("registerWithEmailAndPassword()", () {
//         test(
//           "calls client with register uri",
//           () async {
//             await authApiClient.registerWithEmailAndPassword(authUser);

//             verify(
//               () => dioClient.postUri(_registerUri, options: any(named: "options"), data: any(named: "data")),
//             ).called(1);
//           },
//         );

//         test(
//           "calls [AuthUser().toFormData] method",
//           () async {
//             await authApiClient.registerWithEmailAndPassword(authUser);

//             verify(() => authUser.toFormData()).called(1);
//           },
//         );

//         test(
//           "returns correct [AuthResponse] when successed "
//           "to register new user",
//           () {
//             expect(
//               authApiClient.registerWithEmailAndPassword(authUser),
//               completion(
//                 isA<AuthResponse>()
//                     .having((response) => response.token, "token", dummyToken)
//                     .having((response) => response.user, "user", User.fromJson(userResponse)),
//               ),
//             );
//           },
//         );

//         test(
//             "throws [RegisterFailure] when status code "
//             "is not 200", () async {
//           when(
//             () => dioClient.postUri(any(), options: any(named: "options"), data: any(named: "data")),
//           ).thenAnswer((_) async => invalidResponse);

//           expectLater(
//             authApiClient.registerWithEmailAndPassword(authUser),
//             throwsA(isA<RegisterAPIFailure>()),
//           );
//         });

//         test(
//           "throw [DioError] when internal dio error is thrown",
//           () {
//             var expetion = DioError(requestOptions: RequestOptions(path: ''));
//             when(
//               () => dioClient.postUri(any(), options: any(named: "options"), data: any(named: "data")),
//             ).thenThrow(expetion);

//             expect(
//               authApiClient.registerWithEmailAndPassword(authUser),
//               throwsA(isA<DioError>()),
//             );
//           },
//         );
//       });

//       group("loginWithEmailAndPassword()", () {
//         test(
//           "calls client with register uri",
//           () async {
//             await authApiClient.loginWithEmailAndPassword(authUser);

//             verify(
//               () => dioClient.postUri(_loginUri, options: any(named: "options"), data: any(named: "data")),
//             ).called(1);
//           },
//         );

//         test(
//           "calls [AuthUser().email] and [AuthUser().password] properties",
//           () async {
//             await authApiClient.loginWithEmailAndPassword(authUser);

//             verify(() => authUser.email).called(1);
//             verify(() => authUser.password).called(1);
//           },
//         );

//         test(
//           "returns correct [AuthResponse] when successed "
//           "to register new user",
//           () {
//             expect(
//               authApiClient.loginWithEmailAndPassword(authUser),
//               completion(
//                 isA<AuthResponse>()
//                     .having((response) => response.token, "token", dummyToken)
//                     .having((response) => response.user, "user", User.fromJson(userResponse)),
//               ),
//             );
//           },
//         );
//         test("throws [LoginFailure] when status code is not 200", () async {
//           when(() => dioClient.postUri(any(), options: any(named: "options"), data: any(named: "data"))).thenAnswer(
//             (_) async => invalidResponse,
//           );

//           expect(authApiClient.loginWithEmailAndPassword(authUser), throwsA(isA<LoginAPIFailure>()));
//         });

//         test(
//           "throw [DioError] when internal dio error is thrown",
//           () {
//             var exp = DioError(requestOptions: RequestOptions(path: 'path/to/the_void'));
//             when(
//               () => dioClient.postUri(any(), options: any(named: "options"), data: any(named: "data")),
//             ).thenThrow(exp);

//             expect(authApiClient.loginWithEmailAndPassword(authUser), throwsA(isA<DioError>()));
//           },
//         );
//       });
//     });

//     group("Fetch current user data", () {
//       const dummyUserToken = "__user_token__";
//       late Response response;
//       setUp(() {
//         response = MockResponse();
//         when(() => response.data).thenReturn(dummyResponse);
//         when(() => response.statusCode).thenReturn(200);
//         when(() => response.statusMessage).thenReturn("success");

//         when(() => dioClient.getUri(any(), options: any(named: "options"))).thenAnswer(
//           (_) async => response,
//         );
//       });

//       test("calls api with correct Uri", () {
//         expect(authApiClient.fetchUserData(dummyUserToken), completes);
//         verify(() => dioClient.getUri(_userDataUri, options: any(named: "options"))).called(1);
//       });

//       test(
//         "throws [FetchUserDataFailure] when status code not 200",
//         () {
//           when(() => dioClient.getUri(any(), options: any(named: "options"))).thenAnswer(
//             (_) async => invalidResponse,
//           );
//           expect(authApiClient.fetchUserData(dummyUserToken), throwsA(isA<FetchUserDataFailure>()));
//         },
//       );

//       test("throws [DioError] when internal error happen", () {
//         var exp = DioError(requestOptions: RequestOptions(path: 'path/to/the_void'));
//         when(() => dioClient.getUri(any(), options: any(named: "options"))).thenThrow(exp);

//         expect(authApiClient.fetchUserData(dummyUserToken), throwsA(isA<DioError>()));
//       });
//     });
//   });
// }
