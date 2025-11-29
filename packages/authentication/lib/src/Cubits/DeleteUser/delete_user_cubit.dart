import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:authentication/src/Repository/auth_repository.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit(this._repository) : super(DeleteUserInitial());

  final AuthRepository _repository;

  /// Perform DeleteUser and delete current user data.
  ///
  void deleteUser() async {
    if (!_repository.isUserLoggedIn()) return;
    emit(DeleteUserInProgress());
    try {
      await _repository.deleteUser();
      emit(DeleteUserSucceeded());
    } catch (e) {
      emit(DeleteUserFailed(e));
    }
  }
}

extension ExtendDeleteUserState on DeleteUserState {
  bool get isLoading => this is DeleteUserInProgress;
  bool get isDeleted => this is DeleteUserSucceeded;
  bool get isFailed => this is DeleteUserFailed;
}
