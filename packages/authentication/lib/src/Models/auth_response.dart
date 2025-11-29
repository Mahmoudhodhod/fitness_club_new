import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends Equatable {
  final User user;

  @JsonKey(name: "token_type", required: false)
  final String? tokenType;

  @JsonKey(name: "expires_at", required: false)
  final DateTime? expiresAt;

  @JsonKey(name: "access_token", required: false)
  final String? token;

  @JsonKey(required: false)
  final String? message;

  const AuthResponse({
    required this.user,
    this.tokenType,
    this.expiresAt,
    this.token,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

// ignore: unused_element
  _() => _$AuthResponseToJson(this);

  bool get isNotVerified => message != null && !user.verified;

  bool get isVerified => !isNotVerified;

  @override
  List<Object?> get props => [user, token, tokenType];
}
