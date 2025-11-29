import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_week.g.dart';

@JsonSerializable()
class PlanWeeksResponse extends Equatable {
  @JsonKey(name: 'plan_weeks')
  final List<PlanWeek> weeks;

  const PlanWeeksResponse({
    required this.weeks,
  });

  factory PlanWeeksResponse.fromJson(Map<String, dynamic> json) => _$PlanWeeksResponseFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlanWeeksResponseToJson(this);

  @override
  List<Object> get props => [weeks];
}

@JsonSerializable()
class PlanWeek extends Equatable {
  final int id;

  @JsonKey(name: "plan_id")
  final int planID;

  @JsonKey(name: 'plan_week_days')
  final List<WeekDay> days;

  const PlanWeek({
    required this.id,
    required this.planID,
    required this.days,
  });

  factory PlanWeek.fromJson(Map<String, dynamic> json) => _$PlanWeekFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlanWeekToJson(this);

  @override
  List<Object> get props => [id, planID, days];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class WeekDay extends Equatable {
  final int id;

  @JsonKey(name: "plan_week_id")
  final int weekID;

  @JsonKey(name: "day")
  final String name;

  @JsonKey(name: "day_exercises_count", defaultValue: 0)
  final int exercisesCount;

  const WeekDay({
    required this.id,
    required this.weekID,
    required this.name,
    required this.exercisesCount,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) => _$WeekDayFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$WeekDayToJson(this);

  @override
  List<Object> get props => [id, weekID, name, exercisesCount];

  @override
  bool? get stringify => true;
}
