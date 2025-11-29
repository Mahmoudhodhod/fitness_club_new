part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutInProgress extends LogoutState {}

class LogoutSucceeded extends LogoutState {}

class LogoutFailed extends LogoutState {
  final Object? e;
  const LogoutFailed([this.e]);

  @override
  String toString() => "LogoutFailed";

  @override
  List<Object?> get props => [e];
}
