// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubExercisesResponse _$SubExercisesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubExercisesResponse',
      json,
      ($checkedConvert) {
        final val = SubExercisesResponse(
          exercises: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => SubExercise.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'exercises': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$SubExercisesResponseToJson(
        SubExercisesResponse instance) =>
    <String, dynamic>{
      'data': instance.exercises.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

SubExercise _$SubExerciseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SubExercise',
      json,
      ($checkedConvert) {
        final val = SubExercise(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          bodyPart: $checkedConvert('body_part', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          steps: $checkedConvert(
              'steps',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  []),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
          isFavorite:
              $checkedConvert('is_favorite', (v) => v as bool? ?? false),
          favoriteCount: $checkedConvert(
              'favorites_count', (v) => (v as num?)?.toInt() ?? 0),
          primary: $checkedConvert(
              'primary', (v) => SideMuscle.fromJson(v as Map<String, dynamic>)),
          secondary: $checkedConvert('secondary',
              (v) => SideMuscle.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'bodyPart': 'body_part',
        'isFavorite': 'is_favorite',
        'favoriteCount': 'favorites_count'
      },
    );

Map<String, dynamic> _$SubExerciseToJson(SubExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'body_part': instance.bodyPart,
      'description': instance.description,
      'steps': instance.steps,
      'assets': instance.assets.toJson(),
      'is_favorite': instance.isFavorite,
      'favorites_count': instance.favoriteCount,
      'primary': instance.primary.toJson(),
      'secondary': instance.secondary.toJson(),
    };

SideMuscle _$SideMuscleFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SideMuscle',
      json,
      ($checkedConvert) {
        final val = SideMuscle(
          name: $checkedConvert('title', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'name': 'title'},
    );

Map<String, dynamic> _$SideMuscleToJson(SideMuscle instance) =>
    <String, dynamic>{
      'title': instance.name,
      'assets': instance.assets.toJson(),
    };
