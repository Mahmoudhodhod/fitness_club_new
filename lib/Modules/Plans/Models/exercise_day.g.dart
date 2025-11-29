// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayExercisesResponse _$DayExercisesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'DayExercisesResponse',
      json,
      ($checkedConvert) {
        final val = DayExercisesResponse(
          days: $checkedConvert(
              'day_exercises',
              (v) => (v as List<dynamic>)
                  .map((e) => DayExercise.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'days': 'day_exercises'},
    );

DayExercise _$DayExerciseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DayExercise',
      json,
      ($checkedConvert) {
        final val = DayExercise(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          sets: $checkedConvert('sets', (v) => (v as num?)?.toInt() ?? 0),
          reps: $checkedConvert('reps', (v) => v as String? ?? '-'),
          exercises: $checkedConvert(
              'sub_exercises',
              (v) => (v as List<dynamic>)
                  .map((e) => SubExercise.fromJson(e as Map<String, dynamic>))
                  .toList()),
          exerciseType: $checkedConvert(
              'exercise_type',
              (v) => v == null
                  ? null
                  : ExerciseType.fromJson(v as Map<String, dynamic>)),
          plan: $checkedConvert('plan', (v) => v as String? ?? ''),
          restDuration: $checkedConvert(
              'rest_duration', (v) => (v as num?)?.toInt() ?? 0),
          videoUrl: $checkedConvert('video_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'exercises': 'sub_exercises',
        'exerciseType': 'exercise_type',
        'restDuration': 'rest_duration',
        'videoUrl': 'video_url'
      },
    );
