import 'package:authentication/src/Models/models.dart';
import 'package:test/test.dart';

void main() {
  const imagePath = "path/to/image";

  const Map<String, dynamic> dummyUserJson = {
    "id": 15,
    "name": "Mohamed Gamal",
    "email": "a@mail.com",
    "email_verified_at": "2021-08-14T09:34:54.000000Z",
    "gender": "male",
    "image": imagePath,
    "is_admin": false,
    "provider": "authentication",
  };

  const Map<String, dynamic> dummyRegisterUserJson = {
    "name": "Mohamed Gamal",
    "email": "a@mail.com",
    "image": imagePath,
    "gender": "male",
    "is_admin": false,
    "id": 15
  };

  group('User Model', () {
    test("supports value comparisons", () {
      expect(
        User(
          id: 5,
          name: "name",
          email: "email",
          gender: Gender.male,
          profileImagePath: "profileImagePath",
          role: UserRole.client,
          verified: false,
          uuid: '',
        ),
        User(
          id: 5,
          name: "name",
          email: "email",
          gender: Gender.male,
          profileImagePath: "profileImagePath",
          role: UserRole.client,
          verified: false,
          uuid: '',
        ),
      );
    });

    group("fromJson", () {
      test("returns correct user model when register", () {
        expect(
          User.fromJson(dummyRegisterUserJson),
          User(
            id: 15,
            name: "Mohamed Gamal",
            email: "a@mail.com",
            gender: Gender.male,
            profileImagePath: imagePath,
            role: UserRole.client,
            verified: false,
            uuid: '',
          ),
        );
      });
      test("returns correct user model when login", () {
        expect(
          User.fromJson(dummyUserJson),
          User(
            id: 15,
            name: "Mohamed Gamal",
            email: "a@mail.com",
            emailVerifiedAt: DateTime.parse("2021-08-14T09:34:54.000000Z"),
            gender: Gender.male,
            profileImagePath: imagePath,
            role: UserRole.client,
            verified: false,
            uuid: '',
          ),
        );
      });
    });
  });
}
