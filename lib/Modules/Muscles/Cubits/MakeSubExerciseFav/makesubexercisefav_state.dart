part of 'makesubexercisefav_cubit.dart';

abstract class MakeSubExerciseFavState extends Equatable {
  const MakeSubExerciseFavState();

  @override
  List<Object?> get props => [];
}

class MakeSubExerciseFavInitial extends MakeSubExerciseFavState {}

class MakeSubExerciseFavInProgress extends MakeSubExerciseFavState {}

class MakeSubExerciseFavSucceeded extends MakeSubExerciseFavState {
  final bool isFav;
  MakeSubExerciseFavSucceeded({this.isFav = false});

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [isFav];
}

class MakeSubExerciseFavFailed extends ErrorState implements MakeSubExerciseFavState {
  const MakeSubExerciseFavFailed([Object? e]) : super(e);
}
