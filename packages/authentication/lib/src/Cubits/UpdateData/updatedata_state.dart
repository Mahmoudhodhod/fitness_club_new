part of 'updatedata_cubit.dart';

abstract class UpdateDataState extends Equatable {
  const UpdateDataState();

  @override
  List<Object?> get props => [];
}

class UpdateDataInitial extends UpdateDataState {}

class UpdateDataInProgress extends UpdateDataState {}

class UpdateDataSucceeded extends UpdateDataState {
  final User user;

  UpdateDataSucceeded(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateDataFailed extends UpdateDataState {
  final Object? e;
  const UpdateDataFailed([this.e]);

  @override
  String toString() => "UpdateDataFailed";

  @override
  List<Object?> get props => [e];
}
