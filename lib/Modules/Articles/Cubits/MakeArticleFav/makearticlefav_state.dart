part of 'makearticlefav_cubit.dart';

abstract class MakeArticleFavState extends Equatable {
  const MakeArticleFavState();

  @override
  List<Object?> get props => [];
}

class MakearticlefavInitial extends MakeArticleFavState {}

class MakearticlefavInProgress extends MakeArticleFavState {}

class MakearticlefavSucceeded extends MakeArticleFavState {
  final bool isFav;
  MakearticlefavSucceeded({this.isFav = false});

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [isFav];
}

class MakeArticleFavFailed extends ErrorState implements MakeArticleFavState {
  const MakeArticleFavFailed([Object? e]) : super(e);
}
