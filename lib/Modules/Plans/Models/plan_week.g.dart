// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanWeeksResponse _$PlanWeeksResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlanWeeksResponse',
      json,
      ($checkedConvert) {
        final val = PlanWeeksResponse(
          weeks: $checkedConvert(
              'plan_weeks',
              (v) => (v as List<dynamic>)
                  .map((e) => PlanWeek.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'weeks': 'plan_weeks'},
    );

Map<String, dynamic> _$PlanWeeksResponseToJson(PlanWeeksResponse instance) =>
    <String, dynamic>{
      'plan_weeks': instance.weeks.map((e) => e.toJson()).toList(),
    };

PlanWeek _$PlanWeekFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PlanWeek',
      json,
      ($checkedConvert) {
        final val = PlanWeek(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          planID: $checkedConvert('plan_id', (v) => (v as num).toInt()),
          days: $checkedConvert(
              'plan_week_days',
              (v) => (v as List<dynamic>)
                  .map((e) => WeekDay.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'planID': 'plan_id', 'days': 'plan_week_days'},
    );

Map<String, dynamic> _$PlanWeekToJson(PlanWeek instance) => <String, dynamic>{
      'id': instance.id,
      'plan_id': instance.planID,
      'plan_week_days': instance.days.map((e) => e.toJson()).toList(),
    };

WeekDay _$WeekDayFromJson(Map<String, dynamic> json) => $checkedCreate(
      'WeekDay',
      json,
      ($checkedConvert) {
        final val = WeekDay(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          weekID: $checkedConvert('plan_week_id', (v) => (v as num).toInt()),
          name: $checkedConvert('day', (v) => v as String),
          exercisesCount: $checkedConvert(
              'day_exercises_count', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'weekID': 'plan_week_id',
        'name': 'day',
        'exercisesCount': 'day_exercises_count'
      },
    );

Map<String, dynamic> _$WeekDayToJson(WeekDay instance) => <String, dynamic>{
      'id': instance.id,
      'plan_week_id': instance.weekID,
      'day': instance.name,
      'day_exercises_count': instance.exercisesCount,
    };
