// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlansResponse _$PlansResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlansResponse',
      json,
      ($checkedConvert) {
        final val = PlansResponse(
          plans: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => Plan.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'plans': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$PlansResponseToJson(PlansResponse instance) =>
    <String, dynamic>{
      'data': instance.plans.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

Plan _$PlanFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Plan',
      json,
      ($checkedConvert) {
        final val = Plan(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          weeksCount: $checkedConvert(
              'plan_weeks_count', (v) => (v as num?)?.toInt() ?? 0),
          assets: $checkedConvert(
              'assets',
              (v) => v == null
                  ? null
                  : ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'weeksCount': 'plan_weeks_count'},
    );

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'plan_weeks_count': instance.weeksCount,
      'assets': instance.assets?.toJson(),
    };
