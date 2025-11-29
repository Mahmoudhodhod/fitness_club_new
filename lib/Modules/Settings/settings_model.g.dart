// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AppSettings',
      json,
      ($checkedConvert) {
        final val = AppSettings(
          name: $checkedConvert('name', (v) => v as String?),
          logoPath: $checkedConvert('logo', (v) => v as String?),
          version: $checkedConvert('version', (v) => v as String?),
          termsAndConditions:
              $checkedConvert('terms_conditions', (v) => v as String?),
          privacyPolicy: $checkedConvert('privacy_policy', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'logoPath': 'logo',
        'termsAndConditions': 'terms_conditions',
        'privacyPolicy': 'privacy_policy'
      },
    );
