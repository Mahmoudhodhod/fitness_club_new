import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'updatedata_state.dart';

class UpdateDataCubit extends Cubit<UpdateDataState> {
  UpdateDataCubit(this._repository) : super(UpdateDataInitial());

  final AuthRepository _repository;

  ///Update current user data.
  ///
  void updateUserData(UserUpdate newUser) async {
    if (newUser.isEmpty()) return;
    emit(UpdateDataInProgress());
    try {
      final user = await _repository.updateUserData(newUser);
      _repository.userChanged(user);
      emit(UpdateDataSucceeded(user));
    } catch (e) {
      emit(UpdateDataFailed(e));
    }
  }
}
