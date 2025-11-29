// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeepLinkOptions _$DeepLinkOptionsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'DeepLinkOptions',
      json,
      ($checkedConvert) {
        final val = DeepLinkOptions(
          id: $checkedConvert('id', (v) => _$idStringToInt(v as String)),
          type:
              $checkedConvert('type', (v) => $enumDecode(_$ViewTypeEnumMap, v)),
        );
        return val;
      },
    );

Map<String, dynamic> _$DeepLinkOptionsToJson(DeepLinkOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ViewTypeEnumMap[instance.type]!,
    };

const _$ViewTypeEnumMap = {
  ViewType.article: 'article',
  ViewType.subExercise: 'sub_exercise',
  ViewType.mainExercise: 'main_exercise',
  ViewType.plan: 'plan',
};
