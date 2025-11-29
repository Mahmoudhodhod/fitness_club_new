import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_update.g.dart';

@JsonSerializable()
class PasswordUpdate extends Equatable {
  @JsonKey(name: "current_password")
  final String oldPassword;
  @JsonKey(name: "password")
  final String newPassword;
  @JsonKey(name: "password_confirmation")
  final String newPasswordConfirmation;

  const PasswordUpdate({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  PasswordUpdate copyWith({
    String? oldPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) {
    return PasswordUpdate(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      newPasswordConfirmation: newPasswordConfirmation ?? this.newPasswordConfirmation,
    );
  }

  @visibleForTesting
  factory PasswordUpdate.fromJson(Map<String, dynamic> json) => _$PasswordUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordUpdateToJson(this);

  @override
  List<Object> get props => [oldPassword, newPassword, newPasswordConfirmation];
}
