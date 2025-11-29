import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_plan.g.dart';

@JsonSerializable()
class NewPlan extends Equatable {
  @JsonKey(name: 'name')
  final String title;
  final String description;

  const NewPlan({
    required this.title,
    this.description = '',
  });

  @visibleForTesting
  factory NewPlan.fromJson(Map<String, dynamic> json) => _$NewPlanFromJson(json);

  Map<String, dynamic> toJson() => _$NewPlanToJson(this);

  @override
  List<Object?> get props => [title, description];
}
