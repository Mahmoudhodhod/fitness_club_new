// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainExercisesCategoriesResponse _$MainExercisesCategoriesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'MainExercisesCategoriesResponse',
      json,
      ($checkedConvert) {
        final val = MainExercisesCategoriesResponse(
          categories: $checkedConvert(
              'main_exercise_categories',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      MainExercisesCategory.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'categories': 'main_exercise_categories'},
    );

Map<String, dynamic> _$MainExercisesCategoriesResponseToJson(
        MainExercisesCategoriesResponse instance) =>
    <String, dynamic>{
      'main_exercise_categories':
          instance.categories.map((e) => e.toJson()).toList(),
    };

MainExercisesCategory _$MainExercisesCategoryFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'MainExercisesCategory',
      json,
      ($checkedConvert) {
        final val = MainExercisesCategory(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$MainExercisesCategoryToJson(
        MainExercisesCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assets': instance.assets.toJson(),
    };
