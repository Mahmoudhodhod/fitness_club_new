import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'auth_provider.dart';

part 'user.g.dart';

enum Gender { male, female, others }

enum UserRole { client, admin }

@JsonSerializable()
class User extends Equatable {
  final int id;

  final String name;

  final String email;

  @JsonKey(defaultValue: Gender.male)
  final Gender? gender;

  @JsonKey(required: false)
  final DateTime? emailVerifiedAt;

  @JsonKey(name: "image")
  final String profileImagePath;

  @JsonKey(name: "is_admin", fromJson: User.mapRole)
  final UserRole role;

  @JsonKey(defaultValue: false)
  final bool verified;

  @JsonKey(required: false)
  final SocialAccount? socialAccount;

  final String uuid;

  //made nullable to avoid entering it in the constructor.

  @JsonKey(name: 'created_at')
  final DateTime? registeredAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    this.emailVerifiedAt,
    required this.profileImagePath,
    required this.role,
    required this.verified,
    this.socialAccount,
    required this.uuid,
    this.registeredAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Empty user which represents an unauthenticated user.
  static const empty = const User(
    id: -1,
    name: '',
    email: '',
    gender: Gender.male,
    profileImagePath: '',
    role: UserRole.client,
    verified: false,
    uuid: '#%#',
  );

  bool get isSocialAccount => socialAccount != null;

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      gender,
      emailVerifiedAt,
      profileImagePath,
      role,
      verified,
      socialAccount,
      uuid,
    ];
  }

  @override
  bool? get stringify => true;

  @visibleForTesting
  static UserRole mapRole(bool isAdmin) {
    if (isAdmin) return UserRole.admin;
    return UserRole.client;
  }
}

extension Roles on User {
  bool get isClient => role == UserRole.client;
  bool get isAdmin => role == UserRole.admin;

  bool get isLoggedIn => isNotEmpty;
}

@JsonSerializable()
class SocialAccount extends Equatable {
  @JsonKey(name: 'provider_id')
  final String providerID;

  @JsonKey(name: 'provider_name')
  final AuthProvider provider;

  const SocialAccount({
    required this.providerID,
    required this.provider,
  });

  factory SocialAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountFromJson(json);

  Map<String, dynamic> toJson() => _$SocialAccountToJson(this);

  @override
  List<Object> get props => [providerID, provider];

  @override
  bool? get stringify => true;
}
