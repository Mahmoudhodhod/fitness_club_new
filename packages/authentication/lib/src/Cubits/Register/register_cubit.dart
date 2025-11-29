import 'dart:developer';

import 'package:authentication/src/Models/models.dart';
import 'package:authentication/src/Repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(RegisterInitial());

  final AuthRepository _repository;

  ///Perform register with user data.
  ///
  void registerFormSubmitted(AuthUser authUser) async {
    emit(RegisterInProgress());
    try {
      final response = await _repository.registerWithEmailAndPassword(authUser);
      final user = response.user;
      await _repository.saveUser(response);
      log('useruseruseruseruser ${user.toJson()}');
      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterFailed(e));
    }
  }
}
