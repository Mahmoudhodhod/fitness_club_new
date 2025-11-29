part of 'makemainexercisefav_cubit.dart';

abstract class MakeMainExerciseFavState extends Equatable {
  const MakeMainExerciseFavState();

  @override
  List<Object?> get props => [];
}

class MakeMainExerciseFavInitial extends MakeMainExerciseFavState {}

class MakeFavInProgress extends MakeMainExerciseFavState {}

class MakeFavSucceeded extends MakeMainExerciseFavState {
  final bool isFav;
  MakeFavSucceeded({this.isFav = false});

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [isFav];
}

class MakeFavFailed extends ErrorState implements MakeMainExerciseFavState {
  const MakeFavFailed([Object? e]) : super(e);
}
