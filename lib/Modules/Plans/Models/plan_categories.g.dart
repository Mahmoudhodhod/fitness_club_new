// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanCategoriesResponse _$PlanCategoriesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'PlanCategoriesResponse',
      json,
      ($checkedConvert) {
        final val = PlanCategoriesResponse(
          categories: $checkedConvert(
              'plan_categories',
              (v) => (v as List<dynamic>)
                  .map((e) => PlanCategory.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'categories': 'plan_categories'},
    );

Map<String, dynamic> _$PlanCategoriesResponseToJson(
        PlanCategoriesResponse instance) =>
    <String, dynamic>{
      'plan_categories': instance.categories.map((e) => e.toJson()).toList(),
    };

PlanCategory _$PlanCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlanCategory',
      json,
      ($checkedConvert) {
        final val = PlanCategory(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$PlanCategoryToJson(PlanCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
