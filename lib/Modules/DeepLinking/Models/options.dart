import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'options.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ViewType {
  article,
  subExercise,
  mainExercise,
  plan,
}

@JsonSerializable()
class DeepLinkOptions extends Equatable {
  @JsonKey(fromJson: _$idStringToInt)
  final int id;
  final ViewType type;

  @JsonKey(ignore: true)
  final Map<String, dynamic>? metadata;

  const DeepLinkOptions({
    required this.id,
    required this.type,
    this.metadata,
  });

  Map<String, dynamic> toJson() => _$DeepLinkOptionsToJson(this);

  factory DeepLinkOptions.fromJson(Map<String, dynamic> json) => _$DeepLinkOptionsFromJson(json);

  @override
  List<Object?> get props => [id, type, metadata];
}

int _$idStringToInt(String v) {
  return num.parse(v).toInt();
}
