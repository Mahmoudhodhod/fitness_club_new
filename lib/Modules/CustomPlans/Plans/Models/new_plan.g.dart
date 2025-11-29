// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewPlan _$NewPlanFromJson(Map<String, dynamic> json) => $checkedCreate(
      'NewPlan',
      json,
      ($checkedConvert) {
        final val = NewPlan(
          title: $checkedConvert('name', (v) => v as String),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'title': 'name'},
    );

Map<String, dynamic> _$NewPlanToJson(NewPlan instance) => <String, dynamic>{
      'name': instance.title,
      'description': instance.description,
    };
