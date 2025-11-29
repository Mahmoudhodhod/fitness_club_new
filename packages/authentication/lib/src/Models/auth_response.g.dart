// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return $checkedNew('AuthResponse', json, () {
    final val = AuthResponse(
      user: $checkedConvert(
          json, 'user', (v) => User.fromJson(v as Map<String, dynamic>)),
      tokenType: $checkedConvert(json, 'token_type', (v) => v as String?),
      expiresAt: $checkedConvert(json, 'expires_at',
          (v) => v == null ? null : DateTime.parse(v as String)),
      token: $checkedConvert(json, 'access_token', (v) => v as String?),
      message: $checkedConvert(json, 'message', (v) => v as String?),
    );
    return val;
  }, fieldKeyMap: const {
    'tokenType': 'token_type',
    'expiresAt': 'expires_at',
    'token': 'access_token'
  });
}

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'token_type': instance.tokenType,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'access_token': instance.token,
      'message': instance.message,
    };
