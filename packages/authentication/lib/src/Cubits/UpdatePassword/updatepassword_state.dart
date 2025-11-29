part of 'updatepassword_cubit.dart';

abstract class UpdatePasswordState extends Equatable {
  const UpdatePasswordState();

  @override
  List<Object?> get props => [];
}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordInProgress extends UpdatePasswordState {}

class UpdatePasswordSucceded extends UpdatePasswordState {}

class UpdatePasswordFailed extends UpdatePasswordState {
  final Object? e;
  const UpdatePasswordFailed([this.e]);

  @override
  String toString() => "UpdatePasswordFailed";

  @override
  List<Object?> get props => [e];
}
