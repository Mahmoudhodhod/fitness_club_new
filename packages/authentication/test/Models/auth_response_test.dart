import 'package:authentication/src/Models/models.dart';
import 'package:test/test.dart';

void main() {
  const image = "path/to/image";
  const user = const {
    "name": "Ahmed",
    "email": "ahmed@m.com",
    "gender": "male",
    "mobile_token": "mobile_token test",
    "updated_at": "2021-08-16T21:04:45.000000Z",
    "created_at": "2021-08-16T21:04:45.000000Z",
    "image": image,
    "id": 4,
    "roles": [
      {
        "id": 2,
        "name": "client",
        "guard_name": "web",
        "created_at": "2021-08-16T17:52:23.000000Z",
        "updated_at": "2021-08-16T17:52:23.000000Z",
        "pivot": {"model_id": 4, "role_id": 2, "model_type": "App\\Models\\User"}
      }
    ]
  };
  const dummyResponse = const {
    "token_type": "Bearer",
    "access_token": "test_token",
    "user": user,
  };
  group('AuthRepsonse', () {
    test('supports value comparison', () {
      expect(
        AuthResponse.fromJson(dummyResponse),
        isA<AuthResponse>().having((response) => response.token, "token", "test_token").having(
            (response) => response.user,
            "user",
            isA<User>()
                .having((user) => user.id, "id", 4)
                .having((user) => user.name, "name", "Ahmed")
                .having((user) => user.email, "email", "ahmed@m.com")
                .having((user) => user.gender, "gender", Gender.male)
                .having((user) => user.profileImagePath, "image", image)),
      );
    });
    test('supports value comparison', () {
      expect(
        AuthResponse.fromJson({"user": user}),
        AuthResponse(user: User.fromJson(user)),
      );
    });
    test('returns the correct user from response', () {
      expect(
        AuthResponse.fromJson(dummyResponse),
        AuthResponse(
          user: User.fromJson(user),
          token: "test_token",
          tokenType: "Bearer",
        ),
      );
    });
  });
}
