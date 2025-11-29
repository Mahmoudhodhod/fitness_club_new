part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginInProgress extends LoginState {
  const LoginInProgress();
}

class LoginSuccess extends LoginState {
  final User user;
  final bool isVerified;

  const LoginSuccess({
    required this.user,
    this.isVerified = true,
  });

  @override
  String toString() => "LoginSuccess(user: ${user.id})";

  @override
  List<Object> get props => [user];
}

class LoginFailed extends LoginState {
  final Object? e;
  const LoginFailed([this.e]);

  @override
  String toString() => "LoginFailed";

  @override
  List<Object?> get props => [e];
}

class LoginFailedWithUnauthorizedUser extends LoginState {
  const LoginFailedWithUnauthorizedUser();

  @override
  String toString() => "LoginFailedWithUnauthorizedUser()";
}
