part of 'delete_user_cubit.dart';

abstract class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object?> get props => [];
}

class DeleteUserInitial extends DeleteUserState {}

class DeleteUserInProgress extends DeleteUserState {}

class DeleteUserSucceeded extends DeleteUserState {}

class DeleteUserFailed extends DeleteUserState {
  final Object? e;
  const DeleteUserFailed([this.e]);

  @override
  String toString() => "DeleteUserFailed";

  @override
  List<Object?> get props => [e];
}
