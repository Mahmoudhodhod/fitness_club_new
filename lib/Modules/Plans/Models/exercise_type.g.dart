// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseTypesResponse _$ExerciseTypesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ExerciseTypesResponse',
      json,
      ($checkedConvert) {
        final val = ExerciseTypesResponse(
          types: $checkedConvert(
              'exercise_types',
              (v) => (v as List<dynamic>)
                  .map((e) => ExerciseType.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'types': 'exercise_types'},
    );

ExerciseType _$ExerciseTypeFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ExerciseType',
      json,
      ($checkedConvert) {
        final val = ExerciseType(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          title: $checkedConvert('title', (v) => v as String),
          maxExercisesCount: $checkedConvert(
              'max_exercises_count', (v) => (v as num?)?.toInt() ?? 1),
        );
        return val;
      },
      fieldKeyMap: const {'maxExercisesCount': 'max_exercises_count'},
    );
