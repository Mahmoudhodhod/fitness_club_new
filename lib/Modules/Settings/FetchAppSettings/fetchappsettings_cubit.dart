import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../settings_model.dart';
import '../settings_repository.dart';

part 'fetchappsettings_state.dart';

class FetchAppSettingsCubit extends Cubit<FetchAppSettingsState> {
  final SettingsRepository _settingsRepository;

  FetchAppSettingsCubit({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const FetchAppSettingsState());

  Future<void> fetchAppSettings() async {
    emit(state.copyWith(status: FetchAppSettingsStatus.loading));
    try {
      final settings = await _settingsRepository.fetchSettings();
      emit(state.copyWith(
        status: FetchAppSettingsStatus.loaded,
        settings: settings,
      ));
    } catch (e) {
      emit(state.copyWith(status: FetchAppSettingsStatus.loading));
    }
  }
}
