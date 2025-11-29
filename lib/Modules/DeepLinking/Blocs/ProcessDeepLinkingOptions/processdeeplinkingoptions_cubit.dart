import 'package:authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import '../../Controllers/_interface.dart';
import '../../Models/models.dart';

part 'processdeeplinkingoptions_state.dart';

class ProcessDeepLinkingOptionsCubit extends Cubit<ProcessDeepLinkingOptionsState> {
  final AuthRepository _authRepository;
  ProcessDeepLinkingOptionsCubit(this._authRepository) : super(ProcessDeepLinkingOptionsInitial());

  Future<void> executeProcess(
    DeepLinkingProcess process, {
    required DeepLinkOptions options,
  }) async {
    emit(ProcessDeepLinkingOptionsIsLoading());
    try {
      final token = await _authRepository.getUserToken();
      final result = await process.executeProcess(ApiOptions(
        accessToken: token ?? '-',
        deepLinkingOptions: options,
      ));
      // To ensure that process dialog is closed
      Future.delayed(Duration(milliseconds: 500), () {
        process.onProcessFinished(result);
      });
      emit(ProcessDeepLinkingOptionsSucceeded());
    } catch (e) {
      emit(ProcessDeepLinkingOptionsFailure(e));
    }
  }
}
