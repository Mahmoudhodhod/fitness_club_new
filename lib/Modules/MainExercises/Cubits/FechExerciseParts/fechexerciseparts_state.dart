part of 'fechexerciseparts_cubit.dart';

abstract class FetchExercisePartsState extends Equatable {
  const FetchExercisePartsState();

  @override
  List<Object?> get props => [];
}

class FetchExercisePartsInitial extends FetchExercisePartsState {}

class FetchPartsInProgress extends FetchExercisePartsState {}

class FetchPartsSucceeded extends FetchExercisePartsState {
  final List<ExercisePart> parts;
  final int mainExerciseID;

  const FetchPartsSucceeded({
    required this.parts,
    required this.mainExerciseID,
  });

  @override
  String toString() => '''FetchPartsSucceeded(parts: ${parts.length}, 
                                    mainExerciseID: $mainExerciseID)''';

  @override
  List<Object?> get props => [parts, mainExerciseID];
}

class FetchPartsFailed extends ErrorState implements FetchExercisePartsState {
  const FetchPartsFailed([Object? e]) : super(e);
}
