// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartsResponse _$PartsResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PartsResponse',
      json,
      ($checkedConvert) {
        final val = PartsResponse(
          parts: $checkedConvert(
              'exercise_parts',
              (v) => (v as List<dynamic>)
                  .map((e) => ExercisePart.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'parts': 'exercise_parts'},
    );

ExercisePart _$ExercisePartFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ExercisePart',
      json,
      ($checkedConvert) {
        final val = ExercisePart(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          plan: $checkedConvert('plan', (v) => v as String),
          sets: $checkedConvert('sets', (v) => (v as num).toInt()),
          reps: $checkedConvert('reps', (v) => v as String),
          restDuration:
              $checkedConvert('rest_duration', (v) => (v as num).toInt()),
          exerciseType: $checkedConvert('exercise_type',
              (v) => ExerciseType.fromJson(v as Map<String, dynamic>)),
          subExercise: $checkedConvert('sub_exercise',
              (v) => SubExercise.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'restDuration': 'rest_duration',
        'exerciseType': 'exercise_type',
        'subExercise': 'sub_exercise'
      },
    );
