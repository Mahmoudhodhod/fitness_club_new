import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_categories.g.dart';

@JsonSerializable()
class PlanCategoriesResponse extends Equatable {
  @JsonKey(name: 'plan_categories')
  final List<PlanCategory> categories;

  const PlanCategoriesResponse({
    required this.categories,
  });

  factory PlanCategoriesResponse.fromJson(Map<String, dynamic> json) => _$PlanCategoriesResponseFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlanCategoriesResponseToJson(this);

  @override
  List<Object> get props => [categories];
}

@JsonSerializable()
class PlanCategory extends Equatable {
  final int id;
  final String name;

  const PlanCategory({
    required this.id,
    required this.name,
  });

  factory PlanCategory.fromJson(Map<String, dynamic> json) => _$PlanCategoryFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlanCategoryToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  bool? get stringify => true;
}
