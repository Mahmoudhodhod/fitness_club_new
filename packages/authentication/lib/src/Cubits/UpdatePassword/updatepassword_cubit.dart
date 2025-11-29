import 'package:authentication/src/Models/models.dart';
import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'updatepassword_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit(this._repository) : super(UpdatePasswordInitial());
  final AuthRepository _repository;

  ///Update current user password.
  ///
  void updateUserPassword(PasswordUpdate newPassword) async {
    emit(UpdatePasswordInProgress());

    try {
      await _repository.updateUserPassword(newPassword);
      await Future.delayed(Duration(seconds: 1));
      emit(UpdatePasswordSucceded());
    } catch (e) {
      emit(UpdatePasswordFailed(e));
    }
  }
}
