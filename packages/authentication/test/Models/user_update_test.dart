import 'dart:io';

import 'package:authentication/src/Models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FakeFile extends Fake implements File {}

class MockUserUpdate extends Mock implements UserUpdate {}

void main() {
  group('UserUpdate Model', () {
    test("supports value comparisons", () {
      expect(
        UserUpdate(name: "name"),
        UserUpdate(name: "name"),
      );
    });

    test("returns object with updated field when passed", () {
      expect(
        UserUpdate(email: "email").copyWith(email: "new_email"),
        UserUpdate(email: "new_email"),
      );
    });

    group("getDataAsMap()", () {
      test("returns only name if only givin", () {
        final user = UserUpdate(name: "Ahmed");
        expect(
          user.toMap(),
          completion(
            isA<Map<String, dynamic>>()
                .having((map) => map["name"], "name", "Ahmed")
                .having((map) => map.length, "length", equals(1)),
          ),
        );
      });

      test("returns only email if only givin", () {
        final user = UserUpdate(email: "ahmed@mail.com");
        expect(
          user.toMap(),
          completion(
            isA<Map<String, dynamic>>()
                .having((map) => map["email"], "email", "ahmed@mail.com")
                .having((map) => map.length, "length", equals(1)),
          ),
        );
      });
    });

    group("getUpdatedData()", () {
      test("returns null if data map is empty", () {
        final user = UserUpdate();
        expect(user.getUpdatedData(), completion(isNull));
      });
    });
  });
}
