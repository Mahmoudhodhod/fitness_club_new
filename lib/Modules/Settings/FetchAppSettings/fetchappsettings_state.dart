part of 'fetchappsettings_cubit.dart';

enum FetchAppSettingsStatus {
  initial,
  loading,
  loaded,
  failed,
}

class FetchAppSettingsState extends Equatable {
  final FetchAppSettingsStatus status;
  final AppSettings? settings;

  const FetchAppSettingsState({
    this.status = FetchAppSettingsStatus.initial,
    this.settings,
  });

  @override
  List<Object?> get props => [status, settings];

  FetchAppSettingsState copyWith({
    FetchAppSettingsStatus? status,
    AppSettings? settings,
  }) {
    return FetchAppSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }
}
