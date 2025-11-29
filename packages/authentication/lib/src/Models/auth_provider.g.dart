// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthCredential _$OAuthCredentialFromJson(Map<String, dynamic> json) {
  return $checkedNew('OAuthCredential', json, () {
    final val = OAuthCredential(
      token: $checkedConvert(json, 'token', (v) => v as String),
      provider: $checkedConvert(
          json, 'provider', (v) => _$enumDecode(_$AuthProviderEnumMap, v)),
    );
    return val;
  });
}

Map<String, dynamic> _$OAuthCredentialToJson(OAuthCredential instance) =>
    <String, dynamic>{
      'token': instance.token,
      'provider': _$AuthProviderEnumMap[instance.provider],
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

const _$AuthProviderEnumMap = {
  AuthProvider.facebook: 'facebook',
  AuthProvider.apple: 'apple',
  AuthProvider.google: 'google',
};
