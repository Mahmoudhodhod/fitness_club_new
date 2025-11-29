import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_asset.g.dart';

@JsonSerializable()
class ImageAsset extends Equatable {
  final String url;

  @JsonKey(name: 'app_preview')
  final String preview;

  const ImageAsset({
    required this.url,
    required this.preview,
  });

  const ImageAsset.empty()
      : url = '',
        preview = '';

  factory ImageAsset.fromJson(Map<String, dynamic> json) => _$ImageAssetFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAssetToJson(this);

  @override
  List<Object> get props => [url, preview];
}
