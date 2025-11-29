// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAsset _$ImageAssetFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ImageAsset',
      json,
      ($checkedConvert) {
        final val = ImageAsset(
          url: $checkedConvert('url', (v) => v as String),
          preview: $checkedConvert('app_preview', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'preview': 'app_preview'},
    );

Map<String, dynamic> _$ImageAssetToJson(ImageAsset instance) =>
    <String, dynamic>{
      'url': instance.url,
      'app_preview': instance.preview,
    };
