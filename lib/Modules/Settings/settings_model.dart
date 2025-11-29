import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable(createToJson: false)
class AppSettings extends Equatable {
  final String? name;

  @JsonKey(name: 'logo')
  final String? logoPath;

  final String? version;

  @JsonKey(name: 'terms_conditions')
  final String? termsAndConditions;

  final String? privacyPolicy;

  AppSettings({
    this.name,
    this.logoPath,
    this.version,
    this.termsAndConditions,
    this.privacyPolicy,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  @override
  List<Object?> get props {
    return [
      name,
      logoPath,
      version,
      termsAndConditions,
      privacyPolicy,
    ];
  }
}
