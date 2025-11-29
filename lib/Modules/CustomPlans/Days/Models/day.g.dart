// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewDayExercise _$NewDayExerciseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'NewDayExercise',
      json,
      ($checkedConvert) {
        final val = NewDayExercise(
          sets: $checkedConvert('sets', (v) => (v as num).toInt()),
          reps: $checkedConvert('reps', (v) => v as String),
          restDuration:
              $checkedConvert('rest_duration', (v) => (v as num?)?.toInt()),
          plan: $checkedConvert('plan', (v) => v as String?),
          exerciseTypeId:
              $checkedConvert('exercise_type_id', (v) => (v as num).toInt()),
          subexercisesIds: $checkedConvert(
              'sub_exercise_ids',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'restDuration': 'rest_duration',
        'exerciseTypeId': 'exercise_type_id',
        'subexercisesIds': 'sub_exercise_ids'
      },
    );

Map<String, dynamic> _$NewDayExerciseToJson(NewDayExercise instance) =>
    <String, dynamic>{
      'sets': instance.sets,
      'reps': instance.reps,
      'rest_duration': instance.restDuration,
      'plan': instance.plan,
      'exercise_type_id': instance.exerciseTypeId,
      'sub_exercise_ids': instance.subexercisesIds,
    };
