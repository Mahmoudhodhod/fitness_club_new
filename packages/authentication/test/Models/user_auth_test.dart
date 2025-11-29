import 'dart:io';

import 'package:authentication/src/Models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthUser extends Mock implements AuthUser {}

class FakeFile extends Fake implements File {}

void main() {
  group('UserAuth', () {
    final email = "ahmed@mail.com";
    final password = "p@ssword";
    group("toJson", () {
      test(
        "returns correct json data "
        "when calling toJson()",
        () {
          final user = AuthUser(
            email: email,
            password: password,
            gender: Gender.male,
            name: "Ahmed",
            passwordConfirmation: password,
          );
          expect(user.toJson(), {
            "email": email,
            "password": password,
            "gender": "male",
            "name": "Ahmed",
            "password_confirmation": password
          });
        },
      );
    });

    group("toFormData", () {
      test("converts [AuthUser] to formData", () {
        final authUser = AuthUser(
          email: email,
          password: password,
          passwordConfirmation: password,
          gender: Gender.male,
          image: FakeFile(),
          name: "name",
        );

        expect(authUser.toFormData(), isNotNull);
      });
    });

    test("supports value comparisons", () {
      expect(
        AuthUser(email: email, password: password),
        AuthUser(email: email, password: password),
      );
    });
    test("returns same object when no properties are passed", () {
      expect(
        AuthUser(email: email, password: password),
        AuthUser(email: email, password: password),
      );
    });
  });
}
