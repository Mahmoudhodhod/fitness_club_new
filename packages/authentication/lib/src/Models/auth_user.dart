import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:utilities/utilities.dart';

import 'models.dart';

part 'auth_user.g.dart';

///User object used in `login` and `Register`.
///
@JsonSerializable()
class AuthUser extends Equatable {
  @JsonKey(required: false)
  final String? name;

  final String email;

  final String password;

  @JsonKey(required: false, name: "password_confirmation")
  final String? passwordConfirmation;

  @JsonKey(required: false)
  final Gender? gender;

  @JsonKey(ignore: true)
  final File? image;

  ///User object used in `login` and `Register`.
  ///
  AuthUser({
    this.name,
    required this.email,
    required this.password,
    this.passwordConfirmation,
    this.gender,
    this.image,
  });

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  // ignore: unused_element
  void _() => _$AuthUserFromJson({});

  FormData get formData {
    return FormData.fromMap({});
  }

  Future<FormData> toFormData() async {
    final _image = await MultipartFile.fromFile(this.image!.path);
    final dataMap = mergeMaps<String, dynamic>([
      this.toJson(),
      {"image": _image}
    ]);
    return FormData.fromMap(dataMap);
  }

  static Future<AuthUser> fakeUser({String? email, File? image}) async {
    final faker = Faker();
    var password = faker.internet.password();
    return AuthUser(
      email: email ?? faker.internet.email(),
      password: password,
      passwordConfirmation: password,
      name: faker.person.name(),
      gender: Gender.male,
      image: image ?? File(''),
    );
  }

  @override
  List<Object?> get props {
    return [
      name,
      email,
      password,
      passwordConfirmation,
      gender,
      image,
    ];
  }

  @override
  bool? get stringify => true;
}
