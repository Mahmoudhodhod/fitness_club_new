// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainExercisesResponse _$MainExercisesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'MainExercisesResponse',
      json,
      ($checkedConvert) {
        final val = MainExercisesResponse(
          exercises: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => MainExercise.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'exercises': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$MainExercisesResponseToJson(
        MainExercisesResponse instance) =>
    <String, dynamic>{
      'data': instance.exercises.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

MainExercise _$MainExerciseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MainExercise',
      json,
      ($checkedConvert) {
        final val = MainExercise(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          rating:
              $checkedConvert('power_rating', (v) => (v as num?)?.toInt() ?? 0),
          parts: $checkedConvert(
              'exercise_parts_count', (v) => (v as num).toInt()),
          isFavorite:
              $checkedConvert('is_favorite', (v) => v as bool? ?? false),
          favoritesCount:
              $checkedConvert('favorites_count', (v) => (v as num).toInt()),
          content: $checkedConvert('content', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'rating': 'power_rating',
        'parts': 'exercise_parts_count',
        'isFavorite': 'is_favorite',
        'favoritesCount': 'favorites_count'
      },
    );

Map<String, dynamic> _$MainExerciseToJson(MainExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'power_rating': instance.rating,
      'exercise_parts_count': instance.parts,
      'is_favorite': instance.isFavorite,
      'favorites_count': instance.favoritesCount,
      'content': instance.content,
      'assets': instance.assets.toJson(),
    };
