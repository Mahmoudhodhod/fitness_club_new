// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAction _$PostActionFromJson(Map<String, dynamic> json) {
  return PostAction(
    modelID: json['model_id'] as int,
    action: _$enumDecode(_$ActionEnumMap, json['model']),
  );
}

Map<String, dynamic> _$PostActionToJson(PostAction instance) =>
    <String, dynamic>{
      'model': _$ActionEnumMap[instance.action],
      'model_id': instance.modelID,
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

const _$ActionEnumMap = {
  Action.article: 'article',
  Action.mainExercise: 'main_exercise',
  Action.subExercise: 'sub_exercise',
};
