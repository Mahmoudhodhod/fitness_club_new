part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterInProgress extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess({required this.user});

  @override
  String toString() => "RegisterSuccess(user: ${user.id})";

  @override
  List<Object> get props => [user];
}

class RegisterFailed extends RegisterState {
  final Object? e;
  const RegisterFailed([this.e]);

  @override
  String toString() => "RegisterFailed";

  @override
  List<Object?> get props => [e];
}
