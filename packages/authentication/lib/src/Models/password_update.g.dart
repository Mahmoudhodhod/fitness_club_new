// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordUpdate _$PasswordUpdateFromJson(Map<String, dynamic> json) {
  return $checkedNew('PasswordUpdate', json, () {
    final val = PasswordUpdate(
      oldPassword:
          $checkedConvert(json, 'current_password', (v) => v as String),
      newPassword: $checkedConvert(json, 'password', (v) => v as String),
      newPasswordConfirmation:
          $checkedConvert(json, 'password_confirmation', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {
    'oldPassword': 'current_password',
    'newPassword': 'password',
    'newPasswordConfirmation': 'password_confirmation'
  });
}

Map<String, dynamic> _$PasswordUpdateToJson(PasswordUpdate instance) =>
    <String, dynamic>{
      'current_password': instance.oldPassword,
      'password': instance.newPassword,
      'password_confirmation': instance.newPasswordConfirmation,
    };
