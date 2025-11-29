import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("UpdatePassword Model", () {
    test("supports value comparisons", () {
      expect(
        PasswordUpdate(
          oldPassword: '',
          newPassword: '',
          newPasswordConfirmation: '',
        ),
        PasswordUpdate(
          oldPassword: '',
          newPassword: '',
          newPasswordConfirmation: '',
        ),
      );
    });

    test("returns object with updated field when passed", () {
      expect(
        PasswordUpdate(
          oldPassword: '',
          newPassword: '',
          newPasswordConfirmation: '',
        ).copyWith(oldPassword: "old_p@ssword"),
        PasswordUpdate(
          oldPassword: 'old_p@ssword',
          newPassword: '',
          newPasswordConfirmation: '',
        ),
      );
    });

    test("toJson()", () {
      expect(
        PasswordUpdate(
          oldPassword: 'old@passord',
          newPassword: 'new@passord',
          newPasswordConfirmation: 'new@passord#confirmation',
        ).toJson(),
        {
          "current_password": 'old@passord',
          "password": 'new@passord',
          "password_confirmation": 'new@passord#confirmation',
        },
      );
    });
  });
}
