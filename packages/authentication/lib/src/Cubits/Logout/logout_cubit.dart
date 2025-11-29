import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _repository;
  final FetchDataCubit _fetchDataCubit;
  LogoutCubit(this._repository, this._fetchDataCubit) : super(LogoutInitial());

  /// Perform logout and delete current user data.
  ///
  void logoutSubmitted() async {
    emit(LogoutInProgress());
    try {
      await _repository.logout();
      emit(LogoutSucceeded());
      _fetchDataCubit.cleanCurrentUser();
    } catch (e) {
      emit(LogoutFailed(e));
    }
  }
}

extension ExtendState on LogoutState {
  bool get isLoading => this is LogoutInProgress;
  bool get isLoggedOut => this is LogoutSucceeded;
  bool get isFailed => this is LogoutFailed;
}
