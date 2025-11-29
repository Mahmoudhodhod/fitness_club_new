// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return $checkedNew('User', json, () {
    final val = User(
      id: $checkedConvert(json, 'id', (v) => v as int),
      name: $checkedConvert(json, 'name', (v) => v as String),
      email: $checkedConvert(json, 'email', (v) => v as String),
      gender: $checkedConvert(json, 'gender',
              (v) => _$enumDecodeNullable(_$GenderEnumMap, v)) ??
          Gender.male,
      emailVerifiedAt: $checkedConvert(json, 'email_verified_at',
          (v) => v == null ? null : DateTime.parse(v as String)),
      profileImagePath: $checkedConvert(json, 'image', (v) => v as String),
      role: $checkedConvert(json, 'is_admin', (v) => User.mapRole(v as bool)),
      verified: $checkedConvert(json, 'verified', (v) => v as bool?) ?? false,
      socialAccount: $checkedConvert(
          json,
          'social_account',
          (v) => v == null
              ? null
              : SocialAccount.fromJson(v as Map<String, dynamic>)),
      uuid: $checkedConvert(json, 'uuid', (v) => v as String),
      registeredAt: $checkedConvert(json, 'created_at',
          (v) => v == null ? null : DateTime.parse(v as String)),
    );
    return val;
  }, fieldKeyMap: const {
    'emailVerifiedAt': 'email_verified_at',
    'profileImagePath': 'image',
    'role': 'is_admin',
    'socialAccount': 'social_account',
    'registeredAt': 'created_at'
  });
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender],
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'image': instance.profileImagePath,
      'is_admin': _$UserRoleEnumMap[instance.role],
      'verified': instance.verified,
      'social_account': instance.socialAccount?.toJson(),
      'uuid': instance.uuid,
      'created_at': instance.registeredAt?.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.others: 'others',
};

const _$UserRoleEnumMap = {
  UserRole.client: 'client',
  UserRole.admin: 'admin',
};

SocialAccount _$SocialAccountFromJson(Map<String, dynamic> json) {
  return $checkedNew('SocialAccount', json, () {
    final val = SocialAccount(
      providerID: $checkedConvert(json, 'provider_id', (v) => v as String),
      provider: $checkedConvert(
          json, 'provider_name', (v) => _$enumDecode(_$AuthProviderEnumMap, v)),
    );
    return val;
  }, fieldKeyMap: const {
    'providerID': 'provider_id',
    'provider': 'provider_name'
  });
}

Map<String, dynamic> _$SocialAccountToJson(SocialAccount instance) =>
    <String, dynamic>{
      'provider_id': instance.providerID,
      'provider_name': _$AuthProviderEnumMap[instance.provider],
    };

const _$AuthProviderEnumMap = {
  AuthProvider.facebook: 'facebook',
  AuthProvider.apple: 'apple',
  AuthProvider.google: 'google',
};
